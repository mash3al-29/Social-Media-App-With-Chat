abstract class LoginStates{}

class InitialLogin extends LoginStates{}

class LoginLoading extends LoginStates{}

class LoginSuccess extends LoginStates{}

class LoginError extends LoginStates{
  final dynamic error;

  LoginError(this.error);

}