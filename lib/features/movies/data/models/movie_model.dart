import 'package:pocketbase/pocketbase.dart';
import '../../domain/entities/movies_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.titulo,
    required super.sinopsis,
    required super.genero,
    required super.duracion,
    required super.clasificacion,
    required super.fechaEstreno,
    required super.horarios,
    required super.imagenes,
    required super.posterUrl,
    required super.created,
    required super.updated,
  });

  factory MovieModel.fromRecord(RecordModel record, String baseUrl) {
    final data = record.data;

    // Obtener URLs de las imágenes desde PocketBase
    List<String> imageUrls = [];
    if (data['imagenes'] != null && data['imagenes'] is List) {
      imageUrls = (data['imagenes'] as List).map((filename) {
        return '$baseUrl/api/files/${record.collectionId}/${record.id}/$filename';
      }).toList();
    }

    // URL del poster principal
    String posterUrl = '';
    if (imageUrls.isNotEmpty) {
      posterUrl = imageUrls.first;
    }

    // Parsear horarios
    List<String> horarios = [];
    if (data['horarios'] != null) {
      if (data['horarios'] is List) {
        horarios = (data['horarios'] as List).map((e) => e.toString()).toList();
      } else if (data['horarios'] is String) {
        horarios = (data['horarios'] as String)
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
    }

    return MovieModel(
      id: record.id,
      titulo: data['titulo'] as String? ?? '',
      sinopsis: data['sinopsis'] as String? ?? '',
      genero: data['genero'] as String? ?? '',
      duracion: data['duracion'] as int? ?? 0,
      clasificacion: data['clasificacion'] as String? ?? 'A',
      fechaEstreno: DateTime.parse(data['fecha_estreno'] as String),
      horarios: horarios,
      imagenes: imageUrls,
      posterUrl: posterUrl,
      created: DateTime.parse(record.created),
      updated: DateTime.parse(record.updated),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'sinopsis': sinopsis,
      'genero': genero,
      'duracion': duracion,
      'clasificacion': clasificacion,
      'fecha_estreno': fechaEstreno.toIso8601String(),
      'horarios': horarios,
    };
  }
}
