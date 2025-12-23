import '../constants/app_constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres';
    }

    return null;
  }

  static String? validateRequired(String? value, [String fieldName = 'Este campo']) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'El título es requerido';
    }

    if (value.length > AppConstants.maxTitleLength) {
      return 'El título no puede superar ${AppConstants.maxTitleLength} caracteres';
    }

    return null;
  }

  static String? validateSinopsis(String? value) {
    if (value == null || value.isEmpty) {
      return 'La sinopsis es requerida';
    }

    if (value.length < AppConstants.minSinopsisLength) {
      return 'La sinopsis debe tener al menos ${AppConstants.minSinopsisLength} caracteres';
    }

    if (value.length > AppConstants.maxSinopsisLength) {
      return 'La sinopsis no puede superar ${AppConstants.maxSinopsisLength} caracteres';
    }

    return null;
  }

  static String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'La duración es requerida';
    }

    final duration = int.tryParse(value);
    if (duration == null || duration <= 0) {
      return 'Ingresa una duración válida en minutos';
    }

    if (duration > 500) {
      return 'La duración no puede superar 500 minutos';
    }

    return null;
  }

  static String? validatePasswordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma la contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }
}