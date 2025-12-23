import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String titulo;
  final String sinopsis;
  final String genero;
  final int duracion; // en minutos
  final String clasificacion; // A, B, C
  final DateTime fechaEstreno;
  final List<String> horarios;
  final List<String> imagenes; // URLs de las imágenes
  final String posterUrl; // URL de la imagen principal
  final DateTime created;
  final DateTime updated;

  const MovieEntity({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.genero,
    required this.duracion,
    required this.clasificacion,
    required this.fechaEstreno,
    required this.horarios,
    required this.imagenes,
    required this.posterUrl,
    required this.created,
    required this.updated,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        sinopsis,
        genero,
        duracion,
        clasificacion,
        fechaEstreno,
        horarios,
        imagenes,
        posterUrl,
        created,
        updated,
      ];
}