import 'package:flutter/material.dart';

class AppConstants {
  // Géneros de películas
  static const List<String> generos = [
    'Acción',
    'Comedia',
    'Drama',
    'Terror',
    'Ciencia Ficción',
    'Romance',
    'Animación',
    'Documental',
    'Suspenso',
  ];

  // Clasificaciones
  static const List<String> clasificaciones = ['A', 'B', 'C'];

  // Roles
  static const String roleAdmin = 'administrador';
  static const String roleGuest = 'invitado';

  // Mensajes
  static const String errorGeneral = 'Ha ocurrido un error. Intenta nuevamente.';
  static const String errorNetwork = 'Error de conexión. Verifica tu internet.';
  static const String successLogin = 'Inicio de sesión exitoso';
  static const String successRegister = 'Registro exitoso';
  static const String successLogout = 'Sesión cerrada exitosamente';

  // Validaciones
  static const int minPasswordLength = 8;
  static const int maxTitleLength = 200;
  static const int minSinopsisLength = 10;
  static const int maxSinopsisLength = 2000;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // Formato de fechas
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}

// Extensión para la clasificación
extension ClasificacionExtension on String {
  String get descripcionClasificacion {
    switch (this) {
      case 'A':
        return 'Todo Público';
      case 'B':
        return 'Mayores de 12 años';
      case 'C':
        return 'Mayores de 18 años';
      default:
        return 'Sin clasificar';
    }
  }

  Color get colorClasificacion {
    switch (this) {
      case 'A':
        return const Color(0xFF4CAF50); // Verde
      case 'B':
        return const Color(0xFFFFA726); // Naranja
      case 'C':
        return const Color(0xFFE53935); // Rojo
      default:
        return const Color(0xFF9E9E9E); // Gris
    }
  }
}