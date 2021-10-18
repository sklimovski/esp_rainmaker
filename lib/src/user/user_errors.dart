abstract class RainmakerAuthException implements Exception {
  final String description;

  const RainmakerAuthException(this.description);

  @override
  String toString();
}

class FailedPasswordException extends RainmakerAuthException {
  final String type = "Failed Password";
  const FailedPasswordException()
      : super(
            'There was a problem with your request. You might not have an account.');

  @override
  String toString() => '${super.description}';
}

class UnverifiedEmailException extends RainmakerAuthException {
  final String type = "Unverified Email";
  const UnverifiedEmailException()
      : super('The email used to login has not been verified');

  @override
  String toString() => '${super.description}';
}

class InvalidCredentialsException extends RainmakerAuthException {
  final String type = "Invalid Credentials";
  const InvalidCredentialsException() : super('Incorrect username or password');

  @override
  String toString() => '${super.description}';
}

class UserAlreadyExistsException extends RainmakerAuthException {
  final String type = "A User Already Exists";
  const UserAlreadyExistsException()
      : super('A user with this email already exists');

  @override
  String toString() => '${super.description}';
}

class BadVerificationException extends RainmakerAuthException {
  final String type = "Invalid Verification Code";
  const BadVerificationException()
      : super('The verification code is incorrect');

  @override
  String toString() => '${super.description}';
}

class InvalidEmailException extends RainmakerAuthException {
  final String type = "Invalid Email";
  const InvalidEmailException() : super('The entered email is not valid');

  @override
  String toString() => '${super.description}';
}

class MissingUsernameOrPassword extends RainmakerAuthException {
  final String type = "Missing Credentials";
  const MissingUsernameOrPassword()
      : super('The user name or password is missing');

  @override
  String toString() => '${super.description}';
}

class InvalidPasswordOrUserName extends RainmakerAuthException {
  final String type = "Invalid Password";
  const InvalidPasswordOrUserName()
      : super(
            'Incorrect user name or password. Password must be at least 8 characters long and should contain at least one uppercase, one lowercase character and a number');

  @override
  String toString() => '${super.description}';
}

class UserNameAlreadyVerified extends RainmakerAuthException {
  final String type = "User Name Already Verified";
  const UserNameAlreadyVerified() : super('User name already verified');

  @override
  String toString() => '${super.description}';
}

class IncorrectVerificationCode extends RainmakerAuthException {
  final String type = "Incorrect Verification Code";
  const IncorrectVerificationCode() : super('Verification code is incorrect');

  @override
  String toString() => '${super.description}';
}

class TimeLimitExceeded extends RainmakerAuthException {
  final String type = 'Time Limit Exceeded';
  const TimeLimitExceeded()
      : super('Attempt limit exceeded, please try after some time');

  @override
  String toString() => '${super.description}';
}

class SendingCodeFailed extends RainmakerAuthException {
  final String type = "Could Not Send Verification Code";
  const SendingCodeFailed() : super('Sending verification code failed');

  @override
  String toString() => '${super.description}';
}

class FailedUserCreationException extends RainmakerAuthException {
  final String type = "Failed User Creation";
  const FailedUserCreationException() : super('Creating user failed');

  @override
  String toString() => '${super.description}';
}

class UserCodeConfirmationException extends RainmakerAuthException {
  final String type = "Failed User Confirmation";
  const UserCodeConfirmationException() : super('User confirmation failed');

  @override
  String toString() => '${super.description}';
}

class BadRefreshTokenException extends RainmakerAuthException {
  final String type = "Authentication Error";
  const BadRefreshTokenException()
      : super(
            'There was a problem authenticating you. Please log out and try again.');

  @override
  String toString() => '${super.description}';
}

class ContextDetailsException extends RainmakerAuthException {
  final String type = "Authentication Error";
  const ContextDetailsException()
      : super('Error in fetching tenant context details');

  @override
  String toString() => '${super.description}';
}
