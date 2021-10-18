abstract class RainmakerAuthException implements Exception {
  final String description;
  final String type;

  const RainmakerAuthException(this.type, this.description);

  @override
  String toString();
}

class FailedPasswordException extends RainmakerAuthException {
  const FailedPasswordException()
      : super('Failed Password',
            'There was a problem with your request. You might not have an account.');

  @override
  String toString() => '${super.description}';
}

class UnverifiedEmailException extends RainmakerAuthException {
  const UnverifiedEmailException()
      : super("Unverified Email",
            'The email used to login has not been verified');

  @override
  String toString() => '${super.description}';
}

class InvalidCredentialsException extends RainmakerAuthException {
  const InvalidCredentialsException()
      : super("Invalid Credentials", 'Incorrect username or password');

  @override
  String toString() => '${super.description}';
}

class UserAlreadyExistsException extends RainmakerAuthException {
  const UserAlreadyExistsException()
      : super("A User Already Exists", 'A user with this email already exists');

  @override
  String toString() => '${super.description}';
}

class InvalidEmailException extends RainmakerAuthException {
  const InvalidEmailException()
      : super("Invalid Email", 'The entered email is not valid');

  @override
  String toString() => '${super.description}';
}

class MissingUsernameOrPassword extends RainmakerAuthException {
  const MissingUsernameOrPassword()
      : super("Missing Credentials", 'The user name or password is missing');

  @override
  String toString() => '${super.description}';
}

class InvalidPasswordOrUserName extends RainmakerAuthException {
  const InvalidPasswordOrUserName()
      : super("Invalid Password",
            'Incorrect user name or password. Password must be at least 8 characters long and should contain at least one uppercase, one lowercase character and a number');

  @override
  String toString() => '${super.description}';
}

class UserNameAlreadyVerified extends RainmakerAuthException {
  const UserNameAlreadyVerified()
      : super("User Name Already Verified", 'User name already verified');

  @override
  String toString() => '${super.description}';
}

class IncorrectVerificationCode extends RainmakerAuthException {
  const IncorrectVerificationCode()
      : super("Incorrect Verification Code", 'Verification code is incorrect');

  @override
  String toString() => '${super.description}';
}

class TimeLimitExceeded extends RainmakerAuthException {
  const TimeLimitExceeded()
      : super('Time Limit Exceeded',
            'Attempt limit exceeded, please try after some time');

  @override
  String toString() => '${super.description}';
}

class SendingCodeFailed extends RainmakerAuthException {
  const SendingCodeFailed()
      : super("Could Not Send Verification Code",
            'Sending verification code failed');

  @override
  String toString() => '${super.description}';
}

class FailedUserCreationException extends RainmakerAuthException {
  const FailedUserCreationException()
      : super("Failed User Creation", 'Creating user failed');

  @override
  String toString() => '${super.description}';
}

class UserCodeConfirmationException extends RainmakerAuthException {
  const UserCodeConfirmationException()
      : super("Failed User Confirmation", 'User confirmation failed');

  @override
  String toString() => '${super.description}';
}

class BadRefreshTokenException extends RainmakerAuthException {
  const BadRefreshTokenException()
      : super("Authentication Error",
            'There was a problem authenticating you. Please log out and try again.');

  @override
  String toString() => '${super.description}';
}

class ContextDetailsException extends RainmakerAuthException {
  const ContextDetailsException()
      : super(
            "Authentication Error", 'Error in fetching tenant context details');

  @override
  String toString() => '${super.description}';
}
