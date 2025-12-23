import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../movies/domain/entities/movies_entity.dart';
import '../../../movies/presentation/bloc/movie_bloc.dart';
import '../../../movies/presentation/bloc/movie_event.dart';
import '../../../movies/presentation/bloc/movie_state.dart';

class MovieFormPage extends StatefulWidget {
  final MovieEntity? movie;

  const MovieFormPage({super.key, this.movie});

  @override
  State<MovieFormPage> createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _sinopsisController = TextEditingController();
  final _duracionController = TextEditingController();
  
  String _selectedGenero = AppConstants.generos.first;
  String _selectedClasificacion = AppConstants.clasificaciones.first;
  DateTime _selectedDate = DateTime.now();
  final List<String> _horarios = [];
  final TextEditingController _horarioController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  bool get isEditing => widget.movie != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadMovieData();
    }
  }

  void _loadMovieData() {
    final movie = widget.movie!;
    _tituloController.text = movie.titulo;
    _sinopsisController.text = movie.sinopsis;
    _duracionController.text = movie.duracion.toString();
    _selectedGenero = movie.genero;
    _selectedClasificacion = movie.clasificacion;
    _selectedDate = movie.fechaEstreno;
    _horarios.addAll(movie.horarios);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _sinopsisController.dispose();
    _duracionController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
      });
    }
  }

  void _addHorario() {
    if (_horarioController.text.isNotEmpty) {
      setState(() {
        _horarios.add(_horarioController.text.trim());
        _horarioController.clear();
      });
    }
  }

  void _removeHorario(int index) {
    setState(() {
      _horarios.removeAt(index);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_horarios.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agrega al menos un horario'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final duracion = int.parse(_duracionController.text);

      if (isEditing) {
        context.read<MovieBloc>().add(
              UpdateMovie(
                id: widget.movie!.id,
                titulo: _tituloController.text.trim(),
                sinopsis: _sinopsisController.text.trim(),
                genero: _selectedGenero,
                duracion: duracion,
                clasificacion: _selectedClasificacion,
                fechaEstreno: _selectedDate,
                horarios: _horarios,
                newImagenes: _selectedImages.isEmpty ? null : _selectedImages,
              ),
            );
      } else {
        context.read<MovieBloc>().add(
              CreateMovie(
                titulo: _tituloController.text.trim(),
                sinopsis: _sinopsisController.text.trim(),
                genero: _selectedGenero,
                duracion: duracion,
                clasificacion: _selectedClasificacion,
                fechaEstreno: _selectedDate,
                horarios: _horarios,
                imagenes: _selectedImages.isEmpty ? null : _selectedImages,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Película' : 'Nueva Película'),
      ),
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is MovieError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is MovieLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: Validators.validateTitle,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Sinopsis
                  TextFormField(
                    controller: _sinopsisController,
                    decoration: const InputDecoration(
                      labelText: 'Sinopsis',
                      prefixIcon: Icon(Icons.description_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    validator: Validators.validateSinopsis,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Género
                  DropdownButtonFormField<String>(
                    value: _selectedGenero,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: AppConstants.generos.map((genero) {
                      return DropdownMenuItem(
                        value: genero,
                        child: Text(genero),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedGenero = value!;
                            });
                          },
                  ),
                  const SizedBox(height: 16),

                  // Duración
                  TextFormField(
                    controller: _duracionController,
                    decoration: const InputDecoration(
                      labelText: 'Duración (minutos)',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validateDuration,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Clasificación
                  DropdownButtonFormField<String>(
                    value: _selectedClasificacion,
                    decoration: const InputDecoration(
                      labelText: 'Clasificación',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                    items: AppConstants.clasificaciones.map((clasificacion) {
                      return DropdownMenuItem(
                        value: clasificacion,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: clasificacion.colorClasificacion,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  clasificacion,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(clasificacion.descripcionClasificacion),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedClasificacion = value!;
                            });
                          },
                  ),
                  const SizedBox(height: 16),

                  // Fecha de estreno
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Fecha de Estreno'),
                    subtitle: Text(DateFormatter.formatDate(_selectedDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: isLoading ? null : _selectDate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Horarios
                  Text(
                    'Horarios',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _horarioController,
                          decoration: const InputDecoration(
                            hintText: 'Ej: 14:00',
                            prefixIcon: Icon(Icons.schedule),
                          ),
                          enabled: !isLoading,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: isLoading ? null : _addHorario,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_horarios.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _horarios.asMap().entries.map((entry) {
                        return Chip(
                          label: Text(entry.value),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: isLoading ? null : () => _removeHorario(entry.key),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),

                  // Imágenes
                  Text(
                    'Imágenes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _pickImages,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Seleccionar Imágenes'),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(_selectedImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: IconButton.filled(
                                  onPressed: isLoading ? null : () => _removeImage(index),
                                  icon: const Icon(Icons.close, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Botón submit
                  FilledButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Actualizar Película' : 'Crear Película'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}