import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/movies/domain/entities/movies_entity.dart';
import '../../features/movies/presentation/pages/movie_detail_page.dart';
import '../../features/movies/presentation/pages/movie_form_page.dart';
import '../../features/movies/presentation/pages/movie_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String movieList = '/movies';
  static const String movieDetail = '/movies/detail';
  static const String movieForm = '/movies/form';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      
      case movieList:
        return MaterialPageRoute(builder: (_) => const MovieListPage());
      
      case movieDetail:
        final movie = settings.arguments as MovieEntity;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(movie: movie),
        );
      
      case movieForm:
        final movie = settings.arguments as MovieEntity?;
        return MaterialPageRoute(
          builder: (_) => MovieFormPage(movie: movie),
        );
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}