import 'package:dartz/dartz.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/pocketbase_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final PocketBaseService pocketBaseService;

  AuthRepositoryImpl(this.pocketBaseService);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String role,
    String? name,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'role': role,
        if (name != null) 'name': name,
      };

      final record = await pocketBaseService.pb.collection('users').create(body: data);
      
      // Autenticar automáticamente después del registro
      await pocketBaseService.pb.collection('users').authWithPassword(email, password);
      await pocketBaseService.saveAuth();
      
      return Right(UserModel.fromRecord(record));
    } on ClientException catch (e) {
      return Left(AuthFailure(e.response['message'] ?? 'Error en el registro'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authData = await pocketBaseService.pb
          .collection('users')
          .authWithPassword(email, password);
      
      await pocketBaseService.saveAuth();
      
      return Right(UserModel.fromRecord(authData.record!));
    } on ClientException catch (e) {
      return Left(AuthFailure(e.response['message'] ?? 'Credenciales inválidas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      pocketBaseService.pb.authStore.clear();
      await pocketBaseService.clearAuth();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      if (!isAuthenticated()) {
        return const Left(AuthFailure('Usuario no autenticado'));
      }
      
      final user = pocketBaseService.currentUser;
      if (user == null) {
        return const Left(AuthFailure('Usuario no encontrado'));
      }
      
      return Right(UserModel.fromRecord(user));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  bool isAuthenticated() {
    return pocketBaseService.isAuthenticated;
  }
}