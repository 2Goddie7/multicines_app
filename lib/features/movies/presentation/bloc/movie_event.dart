import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {}

class WatchMoviesStarted extends MovieEvent {}

class MoviesUpdated extends MovieEvent {
  final List<dynamic> movies;

  const MoviesUpdated(this.movies);

  @override
  List<Object?> get props => [movies];
}

class LoadMovieDetails extends MovieEvent {
  final String movieId;

  const LoadMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class CreateMovie extends MovieEvent {
  final String titulo;
  final String sinopsis;
  final String genero;
  final int duracion;
  final String clasificacion;
  final DateTime fechaEstreno;
  final List<String> horarios;
  final List<File>? imagenes;

  const CreateMovie({
    required this.titulo,
    required this.sinopsis,
    required this.genero,
    required this.duracion,
    required this.clasificacion,
    required this.fechaEstreno,
    required this.horarios,
    this.imagenes,
  });

  @override
  List<Object?> get props => [
        titulo,
        sinopsis,
        genero,
        duracion,
        clasificacion,
        fechaEstreno,
        horarios,
        imagenes,
      ];
}

class UpdateMovie extends MovieEvent {
  final String id;
  final String? titulo;
  final String? sinopsis;
  final String? genero;
  final int? duracion;
  final String? clasificacion;
  final DateTime? fechaEstreno;
  final List<String>? horarios;
  final List<File>? newImagenes;

  const UpdateMovie({
    required this.id,
    this.titulo,
    this.sinopsis,
    this.genero,
    this.duracion,
    this.clasificacion,
    this.fechaEstreno,
    this.horarios,
    this.newImagenes,
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
        newImagenes,
      ];
}

class DeleteMovie extends MovieEvent {
  final String movieId;

  const DeleteMovie(this.movieId);

  @override
  List<Object?> get props => [movieId];
}