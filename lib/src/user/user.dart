import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/user/response_models.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:esp_rainmaker/src/user/user_errors.dart';
import 'package:http/http.dart';
import 'package:isolate_json/isolate_json.dart';

/// Provides access to methods for managing users.
class User {
  static const String _baseUserEndpoint = 'user';
  static const String _loginEndpoint = 'login';
  static const String _passwordChangeEndpoint = 'password';
  static const String _forgotPasswordEndpoint = 'forgotpassword';

  final URLBase _urlBase;

  /// Contructs object to access user management methods.
  ///
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  User([APIVersion version = APIVersion.v1]) : _urlBase = URLBase(version);

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

    final uri = _urlBase.getPath(_baseUserEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
      'password': password,
    });

    final resp = await post(uri, body: body);
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);

    if (resp.statusCode != 201) {
      handleCreateConfirmUserError(bodyResp['error_code']);
    }
  }

  /// Confirms a new user.
  ///
  /// The username must be the email used to create
  /// the user. The verification code is sent to the
  /// email following the creation of the user. Throws
  /// `BadVerificationException` on a bad code.
  Future<void> confirmUser(String userName, String verifCode) async {
    assert(userName.isNotEmpty);
    assert(verifCode.isNotEmpty);

    final uri = _urlBase.getPath(_baseUserEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
      'verification_code': verifCode,
    });

    final resp = await post(uri, body: body);
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 201) {
      handleCreateConfirmUserError(bodyResp['error_code']);
    }
  }

  // Error Handling for create / confirm user requests

  handleCreateConfirmUserError(errorCode) {
    switch (errorCode) {
      case (101001):
      case (101003):
        throw MissingUsernameOrPassword();
      case (101002):
        throw InvalidEmailException();
      case (101004):
      case (101007):
      case (101009):
        throw InvalidPasswordOrUserName();
      case (101005):
        throw SendingCodeFailed();
      case (101006):
        throw UserAlreadyExistsException();
      case (101011):
        throw UserNameAlreadyVerified();
      case (101008):
        throw FailedUserCreationException();
      case (100008):
        throw ContextDetailsException();
      case (101013):
        throw UserCodeConfirmationException();
      case (101012):
        throw IncorrectVerificationCode();
      case (101019):
        throw TimeLimitExceeded();
      default:
        throw Exception('Unknown Error');
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

    final uri = _urlBase.getPath(_loginEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
      'password': password,
    });

    final resp = await post(uri, body: body);
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
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
    final uri = _urlBase.getPath(_loginEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
      'refreshtoken': refreshToken,
    });

    final resp = await post(uri, body: body);
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
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
    final uri = _urlBase.getPath(_passwordChangeEndpoint);

    final body = await JsonIsolate().encodeJson({
      'password': password,
      'newpassword': newPassword,
    });

    final resp = await put(
      uri,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
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
    final uri = _urlBase.getPath(_forgotPasswordEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
    });

    final resp = await put(uri, body: body);
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
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
    final uri = _urlBase.getPath(_forgotPasswordEndpoint);

    final body = await JsonIsolate().encodeJson({
      'user_name': userName,
      'password': password,
      'verification_code': verificationCode,
    });

    final resp = await put(uri, body: body);
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Updates the name of the user.
  ///
  /// Takes the new name of the user
  /// and their access token. Data is
  /// not used by the Rainmaker service;
  /// it's only for convenient storage of user data.
  Future<void> setName(String name, String accessToken) async {
    final uri = _urlBase.getPath(_baseUserEndpoint);

    final body = await JsonIsolate().encodeJson({
      'name': name,
    });

    final resp = await put(
      uri,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Gets data associated with a user.
  ///
  /// Takes the the access token of the user.
  /// Returns object containing properties associated
  /// with a user.
  Future<UserData> getUser(String accessToken) async {
    final uri = _urlBase.getPath(_baseUserEndpoint);

    final resp = await get(
      uri,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final bodyResp = await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
    return UserData.fromJson(bodyResp);
  }
}
