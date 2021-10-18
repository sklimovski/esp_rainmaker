abstract class RainmakerAuthException implements Exception {
  final String frontFacingText;

  const RainmakerAuthException(this.frontFacingText);

  @override
  String toString();
}

class FailedPasswordException extends RainmakerAuthException {
  const FailedPasswordException()
      : super(
            'There was a problem with your request. You might not have an account.');

  @override
  String toString() => 'FailedPasswordException: ${super.frontFacingText}';
}

class UnverifiedEmailException extends RainmakerAuthException {
  const UnverifiedEmailException()
      : super('The email used to login has not been verified');

  @override
  String toString() => 'UnverifiedEmailException: ${super.frontFacingText}';
}

class InvalidCredentialsException extends RainmakerAuthException {
  const InvalidCredentialsException() : super('Incorrect username or password');

  @override
  String toString() => 'InvalidCredentialsException: ${super.frontFacingText}';
}

class UserAlreadyExistsException extends RainmakerAuthException {
  const UserAlreadyExistsException()
      : super('A user with this email already exists');

  @override
  String toString() => 'UserAlreadyExistsException: ${super.frontFacingText}';
}

class BadVerificationException extends RainmakerAuthException {
  const BadVerificationException()
      : super('The verification code is incorrect');

  @override
  String toString() => 'BadVerificationException: ${super.frontFacingText}';
}

class InvalidEmailException extends RainmakerAuthException {
  const InvalidEmailException() : super('The entered email is not valid');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class MissingUsernameOrPassword extends RainmakerAuthException {
  const MissingUsernameOrPassword()
      : super('The user name or password is missing');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class InvalidPasswordOrUserName extends RainmakerAuthException {
  const InvalidPasswordOrUserName()
      : super(
            'Incorrect user name or password. Password must be at least 8 characters long and should contain at least one uppercase, one lowercase character and a number');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class UserNameAlreadyVerified extends RainmakerAuthException {
  const UserNameAlreadyVerified() : super('User name already verified');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class IncorrectVerificationCode extends RainmakerAuthException {
  const IncorrectVerificationCode() : super('Verification code is incorrect');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class TimeLimitExceeded extends RainmakerAuthException {
  const TimeLimitExceeded()
      : super('Attempt limit exceeded, please try after some time');

  @override
  String toString() => 'InvalidEmailException: ${super.frontFacingText}';
}

class SendingCodeFailed extends RainmakerAuthException {
  const SendingCodeFailed() : super('Sending verification code failed');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}

class FailedUserCreationException extends RainmakerAuthException {
  const FailedUserCreationException() : super('Creating user failed');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}

class UserCodeConfirmationException extends RainmakerAuthException {
  const UserCodeConfirmationException() : super('User confirmation failed');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}

class BadRefreshTokenException extends RainmakerAuthException {
  const BadRefreshTokenException()
      : super(
            'There was a problem authenticating you. Please log out and try again.');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}

class ContextDetailsException extends RainmakerAuthException {
  const ContextDetailsException()
      : super('Error in fetching tenant context details');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}
