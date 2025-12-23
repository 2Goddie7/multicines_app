import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movies_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies();
  
  Future<Either<Failure, MovieEntity>> getMovieById(String id);
  
  Future<Either<Failure, MovieEntity>> createMovie({
    required String titulo,
    required String sinopsis,
    required String genero,
    required int duracion,
    required String clasificacion,
    required DateTime fechaEstreno,
    required List<String> horarios,
    List<File>? imagenes,
  });
  
  Future<Either<Failure, MovieEntity>> updateMovie({
    required String id,
    String? titulo,
    String? sinopsis,
    String? genero,
    int? duracion,
    String? clasificacion,
    DateTime? fechaEstreno,
    List<String>? horarios,
    List<File>? newImagenes,
  });
  
  Future<Either<Failure, void>> deleteMovie(String id);
  
  Stream<List<MovieEntity>> watchMovies();
}