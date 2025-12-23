import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}