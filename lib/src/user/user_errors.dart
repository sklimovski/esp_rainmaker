abstract class RainmakerAuthException implements Exception {
  final String description;
  final String type;
  final String action;

  const RainmakerAuthException(this.type, this.description, this.action);

  @override
  String toString();
}

class FailedPasswordException extends RainmakerAuthException {
  const FailedPasswordException()
      : super(
            'Failed Password',
            'There was a problem with your request. You might not have an account.',
            'Try again');

  @override
  String toString() => '${super.description}';
}

class UnverifiedEmailException extends RainmakerAuthException {
  const UnverifiedEmailException()
      : super(
            "Unverified Email",
            'An account is already associated with this email. Please verify your account to proceed.',
            'Verify account');

  @override
  String toString() => '${super.description}';
}

class InvalidCredentialsException extends RainmakerAuthException {
  const InvalidCredentialsException()
      : super("Invalid Credentials", 'Incorrect username or password',
            'Try again');

  @override
  String toString() => '${super.description}';
}

class UserAlreadyExistsException extends RainmakerAuthException {
  const UserAlreadyExistsException()
      : super(
            "A User Already Exists",
            'An account is already associated with this email. Please try another email.',
            'Try again');

  @override
  String toString() => '${super.description}';
}

class InvalidEmailException extends RainmakerAuthException {
  const InvalidEmailException()
      : super(
            "Invalid Email",
            "There's an error with creating your account. Please try again.",
            'Try again');

  @override
  String toString() => '${super.description}';
}

class MissingUsernameOrPassword extends RainmakerAuthException {
  const MissingUsernameOrPassword()
      : super(
            "Missing Credentials",
            "There's an error with creating your account. Please try again.",
            'Try again');

  @override
  String toString() => '${super.description}';
}

class InvalidPasswordOrUserName extends RainmakerAuthException {
  const InvalidPasswordOrUserName()
      : super(
            "Invalid Password",
            "There's an error with creating your account. Please try again.",
            'Try again');

  @override
  String toString() => '${super.description}';
}

class UserNameAlreadyVerified extends RainmakerAuthException {
  const UserNameAlreadyVerified()
      : super(
            "User Name Already Verified",
            'User name already verified. Please log-in to your account.',
            'Go back to Login');

  @override
  String toString() => '${super.description}';
}

class IncorrectVerificationCode extends RainmakerAuthException {
  const IncorrectVerificationCode()
      : super("Incorrect Verification Code", 'Verification code is incorrect.',
            "Try again");

  @override
  String toString() => '${super.description}';
}

class TimeLimitExceeded extends RainmakerAuthException {
  const TimeLimitExceeded()
      : super('Time Limit Exceeded',
            'Time limit exceeded. Please try again later.', "Go back");

  @override
  String toString() => '${super.description}';
}

class SendingCodeFailed extends RainmakerAuthException {
  const SendingCodeFailed()
      : super(
            "Could Not Send Verification Code",
            "There's an error with verifying your account. Please check your details",
            "Go back");

  @override
  String toString() => '${super.description}';
}

class FailedUserCreationException extends RainmakerAuthException {
  const FailedUserCreationException()
      : super(
            "Failed User Creation",
            "There's an error with verifying your account. Please check your details",
            "Go back");

  @override
  String toString() => '${super.description}';
}

class UserCodeConfirmationException extends RainmakerAuthException {
  const UserCodeConfirmationException()
      : super(
            "Failed User Confirmation",
            "There's an error with verifying your account. Please check your details",
            "Go back");

  @override
  String toString() => '${super.description}';
}

class BadRefreshTokenException extends RainmakerAuthException {
  const BadRefreshTokenException()
      : super(
            "Authentication Error",
            'There was a problem authenticating you. Please log out and try again.',
            "Try again");

  @override
  String toString() => '${super.description}';
}

class ContextDetailsException extends RainmakerAuthException {
  const ContextDetailsException()
      : super(
            "Authentication Error",
            "There's an error with verifying your account. Please check your details",
            "Go back");

  @override
  String toString() => '${super.description}';
}
