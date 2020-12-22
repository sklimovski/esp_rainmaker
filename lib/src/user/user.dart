import 'dart:convert';

import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/user/response_models.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

/// Provides access to methods for managing users.
class User {
  static const String _createConfirmEndpoint = 'user';
  static const String _loginEndpoint = 'login';
  static const String _passwordChangeEndpoint = 'password';
  static const String _forgotPasswordEndpoint = 'forgotpassword';

  String _urlBase;

  /// Contructs object to access user management methods.
  ///
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  User([APIVersion version = APIVersion.v1]) {
    _urlBase = URLBase.getBase(version);
  }

  /// Checks the validity of a password.
  bool _isValidPassword(String password) {
    final isCorrectLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));

    return isCorrectLength && hasUppercase && hasDigits && hasLowercase;
  }

  /// Creates a new user.
  ///
  /// The username must be an email. The password must
  /// be at least 8 characters long. It should contain
  /// at least one uppercase, one lowercase character
  /// and a number. Throws `UserAlreadyExistsException`
  /// if user already exists.
  Future<void> createUser(String userName, String password) async {
    assert(_isValidPassword(password),
        'The password must be at least 8 characters long. It should contain at least one uppercase, one lowercase character and a number.');

    final url = _urlBase + _createConfirmEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
    });

    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 201) {
      if (bodyResp['error_code'] == 101002) {
        throw InvalidEmailException();
      }
      if (bodyResp['error_code'] == 101006) {
        throw UserAlreadyExistsException();
      }
      throw bodyResp['description'];
    }
  }

  /// Confirms a new user.
  ///
  /// The username must be the email used to create
  /// the user. The verification code is sent to the
  /// email following the creation of the user. Throws
  /// `BadVerificationException` on a bad code.
  Future<void> confirmUser(String userName, String verifCode) async {
    assert(userName != null && userName.isNotEmpty);
    assert(verifCode != null && verifCode.isNotEmpty);

    final url = _urlBase + _createConfirmEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'verification_code': verifCode,
    });

    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 201) {
      if (bodyResp['error_code'] == 101002) {
        throw InvalidEmailException();
      }
      if (bodyResp['error_code'] == 101012) {
        throw BadVerificationException();
      }
      throw bodyResp['description'];
    }
  }

  /// Handle a login of an existing user.
  ///
  /// The refresh token in the returned
  /// response can be used to extend a session.
  /// Throws `UnverifiedEmailException` if email is
  /// not verified. Throws `InvalidCredentialsException`
  /// if there is an incorrect username or password.
  Future<LoginSuccessResponse> login(String userName, String password) async {
    assert(_isValidPassword(password),
        'The password must be at least 8 characters long. It should contain at least one uppercase, one lowercase character and a number.');

    final url = _urlBase + _loginEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
    });

    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      if (bodyResp['error_code'] == 101015) {
        throw UnverifiedEmailException();
      } else if (bodyResp['error_code'] == 101009) {
        throw InvalidCredentialsException();
      }
      throw bodyResp['description'];
    }
    return LoginSuccessResponse.fromJson(bodyResp);
  }

  /// Extends a session.
  ///
  /// Uses the refresh token provided upon
  /// logging in.
  Future<ExtendSuccessResponse> extendSession(
      String userName, String refreshToken) async {
    final url = _urlBase + _loginEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'refreshtoken': refreshToken,
    });

    final resp = await post(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      if (bodyResp['error_code'] == 101017) {
        throw BadRefreshTokenException();
      }
      throw bodyResp['description'];
    }
    return ExtendSuccessResponse.fromJson(bodyResp);
  }

  /// Changes a user password.
  ///
  /// Uses the existing password [password] to
  /// change the account password to [newPassword]
  /// with the access token obtained from logging in
  /// or extending a session.
  Future<void> changePassword(
      String password, String newPassword, String accessToken) async {
    final url = _urlBase + _passwordChangeEndpoint;

    final body = jsonEncode({
      'password': password,
      'newpassword': newPassword,
      'accesstoken': accessToken,
    });

    final resp = await put(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      if (bodyResp['error_code'] == 101009) {
        throw InvalidCredentialsException();
      }
      throw bodyResp['description'];
    }
  }

  /// Initiates a forgotten password flow.
  ///
  /// Sends password reset email to the
  /// [userName].
  Future<void> reqForgotPass(String userName) async {
    final url = _urlBase + _forgotPasswordEndpoint;

    final body = jsonEncode({
      'user_name': userName,
    });

    final resp = await put(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      if (bodyResp['error_code'] == 101031) {
        throw FailedPasswordException();
      }
      throw bodyResp['description'];
    }
  }

  /// Handles forgotten password request.
  ///
  /// Takes the user that initiated the request,
  /// their new password, and the verification
  /// code that was sent to their email.
  Future<void> confirmForgotPass(
      String userName, String password, String verificationCode) async {
    final url = _urlBase + _forgotPasswordEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
      'verification_code': verificationCode,
    });

    final resp = await put(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }
}

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

class BadRefreshTokenException extends RainmakerAuthException {
  const BadRefreshTokenException()
      : super(
            'There was a problem authenticating you. Please log out and try again.');

  @override
  String toString() => 'BadRefreshTokenException: ${super.frontFacingText}';
}
