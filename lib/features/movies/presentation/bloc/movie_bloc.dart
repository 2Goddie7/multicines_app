import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/movies_entity.dart';
import '../../domain/usecases/movie_usecases.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase getMoviesUseCase;
  final GetMovieByIdUseCase getMovieByIdUseCase;
  final CreateMovieUseCase createMovieUseCase;
  final UpdateMovieUseCase updateMovieUseCase;
  final DeleteMovieUseCase deleteMovieUseCase;
  final WatchMoviesUseCase watchMoviesUseCase;

  StreamSubscription<List<MovieEntity>>? _moviesSubscription;

  MovieBloc({
    required this.getMoviesUseCase,
    required this.getMovieByIdUseCase,
    required this.createMovieUseCase,
    required this.updateMovieUseCase,
    required this.deleteMovieUseCase,
    required this.watchMoviesUseCase,
  }) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<WatchMoviesStarted>(_onWatchMoviesStarted);
    on<MoviesUpdated>(_onMoviesUpdated);
    on<LoadMovieDetails>(_onLoadMovieDetails);
    on<CreateMovie>(_onCreateMovie);
    on<UpdateMovie>(_onUpdateMovie);
    on<DeleteMovie>(_onDeleteMovie);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await getMoviesUseCase(NoParams());

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) {
        if (movies.isEmpty) {
          emit(const MovieEmpty());
        } else {
          emit(MovieListLoaded(movies));
        }
      },
    );
  }

  Future<void> _onWatchMoviesStarted(
    WatchMoviesStarted event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    await _moviesSubscription?.cancel();
    
    _moviesSubscription = watchMoviesUseCase(NoParams()).listen(
      (movies) {
        add(MoviesUpdated(movies));
      },
    );
  }

  void _onMoviesUpdated(
    MoviesUpdated event,
    Emitter<MovieState> emit,
  ) {
    final movies = event.movies.cast<MovieEntity>();
    if (movies.isEmpty) {
      emit(const MovieEmpty());
    } else {
      emit(MovieListLoaded(movies));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await getMovieByIdUseCase(event.movieId);

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movie) => emit(MovieDetailsLoaded(movie)),
    );
  }

  Future<void> _onCreateMovie(
    CreateMovie event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await createMovieUseCase(CreateMovieParams(
      titulo: event.titulo,
      sinopsis: event.sinopsis,
      genero: event.genero,
      duracion: event.duracion,
      clasificacion: event.clasificacion,
      fechaEstreno: event.fechaEstreno,
      horarios: event.horarios,
      imagenes: event.imagenes,
    ));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movie) {
        emit(const MovieOperationSuccess('Película creada exitosamente'));
        add(LoadMovies());
      },
    );
  }

  Future<void> _onUpdateMovie(
    UpdateMovie event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await updateMovieUseCase(UpdateMovieParams(
      id: event.id,
      titulo: event.titulo,
      sinopsis: event.sinopsis,
      genero: event.genero,
      duracion: event.duracion,
      clasificacion: event.clasificacion,
      fechaEstreno: event.fechaEstreno,
      horarios: event.horarios,
      newImagenes: event.newImagenes,
    ));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movie) {
        emit(const MovieOperationSuccess('Película actualizada exitosamente'));
        add(LoadMovies());
      },
    );
  }

  Future<void> _onDeleteMovie(
    DeleteMovie event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await deleteMovieUseCase(event.movieId);

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (_) {
        emit(const MovieOperationSuccess('Película eliminada exitosamente'));
        add(LoadMovies());
      },
    );
  }

  @override
  Future<void> close() {
    _moviesSubscription?.cancel();
    return super.close();
  }
}