abstract class AuthenticatinState {}

class AuthInitial extends AuthenticatinState {}


//////// SignUp State ////////////////
// class PickImageSuccess extends AuthenticatinState {}
// class PickImageError extends AuthenticatinState {
//   final String msgError;

//   PickImageError({required this.msgError});
// }

class ValidateInputsError extends AuthenticatinState {
  final String msgError;

  ValidateInputsError({required this.msgError});
}

class RegisterationSuccess extends AuthenticatinState {
  final String msgSuccess;

  RegisterationSuccess({required this.msgSuccess});
}
class RegisterationFailed extends AuthenticatinState {
  final String msgError;

  RegisterationFailed({required this.msgError});
}

class AuthLoading extends AuthenticatinState {}

class AuthLoggedIn extends AuthenticatinState {
  final String userId;
  AuthLoggedIn(this.userId);
}

class AuthLoggedOut extends AuthenticatinState {}

class AuthUpdated extends AuthenticatinState {
  final String userId;
  AuthUpdated(this.userId);
}

class AuthNotLoggedIn extends AuthenticatinState {}

class AuthError extends AuthenticatinState {
  final String message;
  AuthError(this.message);
}

// State for area selection
class AreaChangedState extends AuthenticatinState {}