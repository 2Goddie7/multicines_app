import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movies_entity.dart';
import '../repositories/movie_repository.dart';

// Get Movies Use Case
class GetMoviesUseCase implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) async {
    return await repository.getMovies();
  }
}

// Get Movie By Id Use Case
class GetMovieByIdUseCase implements UseCase<MovieEntity, String> {
  final MovieRepository repository;

  GetMovieByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MovieEntity>> call(String id) async {
    return await repository.getMovieById(id);
  }
}

// Create Movie Use Case
class CreateMovieUseCase implements UseCase<MovieEntity, CreateMovieParams> {
  final MovieRepository repository;

  CreateMovieUseCase(this.repository);

  @override
  Future<Either<Failure, MovieEntity>> call(CreateMovieParams params) async {
    return await repository.createMovie(
      titulo: params.titulo,
      sinopsis: params.sinopsis,
      genero: params.genero,
      duracion: params.duracion,
      clasificacion: params.clasificacion,
      fechaEstreno: params.fechaEstreno,
      horarios: params.horarios,
      imagenes: params.imagenes,
    );
  }
}

class CreateMovieParams {
  final String titulo;
  final String sinopsis;
  final String genero;
  final int duracion;
  final String clasificacion;
  final DateTime fechaEstreno;
  final List<String> horarios;
  final List<File>? imagenes;

  CreateMovieParams({
    required this.titulo,
    required this.sinopsis,
    required this.genero,
    required this.duracion,
    required this.clasificacion,
    required this.fechaEstreno,
    required this.horarios,
    this.imagenes,
  });
}

// Update Movie Use Case
class UpdateMovieUseCase implements UseCase<MovieEntity, UpdateMovieParams> {
  final MovieRepository repository;

  UpdateMovieUseCase(this.repository);

  @override
  Future<Either<Failure, MovieEntity>> call(UpdateMovieParams params) async {
    return await repository.updateMovie(
      id: params.id,
      titulo: params.titulo,
      sinopsis: params.sinopsis,
      genero: params.genero,
      duracion: params.duracion,
      clasificacion: params.clasificacion,
      fechaEstreno: params.fechaEstreno,
      horarios: params.horarios,
      newImagenes: params.newImagenes,
    );
  }
}

class UpdateMovieParams {
  final String id;
  final String? titulo;
  final String? sinopsis;
  final String? genero;
  final int? duracion;
  final String? clasificacion;
  final DateTime? fechaEstreno;
  final List<String>? horarios;
  final List<File>? newImagenes;

  UpdateMovieParams({
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
}

// Delete Movie Use Case
class DeleteMovieUseCase implements UseCase<void, String> {
  final MovieRepository repository;

  DeleteMovieUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteMovie(id);
  }
}

// Watch Movies Use Case (Realtime)
class WatchMoviesUseCase implements StreamUseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  WatchMoviesUseCase(this.repository);

  @override
  Stream<List<MovieEntity>> call(NoParams params) {
    return repository.watchMovies();
  }
}