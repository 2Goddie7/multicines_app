import 'package:equatable/equatable.dart';
import '../../domain/entities/movies_entity.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieListLoaded extends MovieState {
  final List<MovieEntity> movies;

  const MovieListLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieDetailsLoaded extends MovieState {
  final MovieEntity movie;

  const MovieDetailsLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieOperationSuccess extends MovieState {
  final String message;

  const MovieOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieEmpty extends MovieState {
  const MovieEmpty();
}