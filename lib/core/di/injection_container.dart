import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/movie_usecases.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../network/pocketbase_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MovieBloc(
      getMoviesUseCase: sl(),
      getMovieByIdUseCase: sl(),
      createMovieUseCase: sl(),
      updateMovieUseCase: sl(),
      deleteMovieUseCase: sl(),
      watchMoviesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProfileBloc(
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use cases - Auth
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Use cases - Movies
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateMovieUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMovieUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMovieUseCase(sl()));
  sl.registerLazySingleton(() => WatchMoviesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => PocketBaseService());
}