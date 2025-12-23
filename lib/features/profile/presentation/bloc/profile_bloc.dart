import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ProfileBloc({
    required this.getCurrentUserUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // Aquí normalmente harías una llamada a un caso de uso de actualización
    // Por ahora, solo recargamos el perfil
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) {
        emit(const ProfileUpdateSuccess('Perfil actualizado exitosamente'));
        emit(ProfileLoaded(user));
      },
    );
  }
}