abstract class RegisterStates{}

class InitialRegister extends RegisterStates{}

class RegisterLoading extends RegisterStates{}

class RegisterSuccess extends RegisterStates{}

class RegisterError extends RegisterStates{
  final dynamic error;

  RegisterError(this.error);
}

class CreateUserWithDataInFireBaseSuccess extends RegisterStates{}

class CreateUserWithDataInFireBaseError extends RegisterStates{
  final dynamic error;

  CreateUserWithDataInFireBaseError(this.error);
}