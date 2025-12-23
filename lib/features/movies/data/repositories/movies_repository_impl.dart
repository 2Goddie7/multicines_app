import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/pocketbase_service.dart';
import '../../domain/entities/movies_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final PocketBaseService pocketBaseService;
  final StreamController<List<MovieEntity>> _moviesController = StreamController.broadcast();

  MovieRepositoryImpl(this.pocketBaseService) {
    _initRealtimeSubscription();
  }

  void _initRealtimeSubscription() {
    pocketBaseService.pb.collection('peliculas').subscribe('*', (e) {
      getMovies().then((result) {
        result.fold(
          (failure) => null,
          (movies) => _moviesController.add(movies),
        );
      });
    });
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies() async {
    try {
      final records = await pocketBaseService.pb
          .collection('peliculas')
          .getFullList(sort: '-created');

      final movies = records
          .map((record) => MovieModel.fromRecord(
                record,
                PocketBaseService.baseUrl,
              ))
          .toList();

      return Right(movies);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.response['message'] ?? 'Error al obtener películas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieById(String id) async {
    try {
      final record = await pocketBaseService.pb.collection('peliculas').getOne(id);
      final movie = MovieModel.fromRecord(record, PocketBaseService.baseUrl);
      return Right(movie);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.response['message'] ?? 'Película no encontrada'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> createMovie({
    required String titulo,
    required String sinopsis,
    required String genero,
    required int duracion,
    required String clasificacion,
    required DateTime fechaEstreno,
    required List<String> horarios,
    List<File>? imagenes,
  }) async {
    try {
      final body = <String, dynamic>{
        'titulo': titulo,
        'sinopsis': sinopsis,
        'genero': genero,
        'duracion': duracion,
        'clasificacion': clasificacion,
        'fecha_estreno': fechaEstreno.toIso8601String(),
        'horarios': horarios,
      };

      // Agregar imágenes si existen
      if (imagenes != null && imagenes.isNotEmpty) {
        for (int i = 0; i < imagenes.length; i++) {
          body['imagenes'] = await http.MultipartFile.fromPath(
            'imagenes',
            imagenes[i].path,
          );
        }
      }

      final record = await pocketBaseService.pb.collection('peliculas').create(
            body: body,
            files: imagenes != null
                ? imagenes.map((file) => http.MultipartFile.fromPath('imagenes', file.path)).toList()
                : null,
          );

      final movie = MovieModel.fromRecord(record, PocketBaseService.baseUrl);
      return Right(movie);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.response['message'] ?? 'Error al crear película'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (titulo != null) body['titulo'] = titulo;
      if (sinopsis != null) body['sinopsis'] = sinopsis;
      if (genero != null) body['genero'] = genero;
      if (duracion != null) body['duracion'] = duracion;
      if (clasificacion != null) body['clasificacion'] = clasificacion;
      if (fechaEstreno != null) body['fecha_estreno'] = fechaEstreno.toIso8601String();
      if (horarios != null) body['horarios'] = horarios;

      final record = await pocketBaseService.pb.collection('peliculas').update(
            id,
            body: body,
            files: newImagenes != null
                ? newImagenes.map((file) => http.MultipartFile.fromPath('imagenes', file.path)).toList()
                : null,
          );

      final movie = MovieModel.fromRecord(record, PocketBaseService.baseUrl);
      return Right(movie);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.response['message'] ?? 'Error al actualizar película'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMovie(String id) async {
    try {
      await pocketBaseService.pb.collection('peliculas').delete(id);
      return const Right(null);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.response['message'] ?? 'Error al eliminar película'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<MovieEntity>> watchMovies() {
    // Cargar películas iniciales
    getMovies();
    return _moviesController.stream;
  }

  void dispose() {
    _moviesController.close();
    pocketBaseService.pb.collection('peliculas').unsubscribe('*');
  }
}