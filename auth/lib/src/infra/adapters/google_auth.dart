import 'package:async/async.dart';
import 'package:auth/src/domain/auth_user_info.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/auth_service_contract.dart';
import '../../domain/credential.dart';
import '../../domain/token.dart';
import '../../infra/api/auth_api_contract.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi _authApi;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn googleSignIn])
      : this._googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<Result<AuthUserInfo>> signIn() async {
    await _handleGoogleSignIn();
    if (_currentUser == null)
      return Result.error('Failed to SignIn with Google');
    Credential credential = Credential(
      type: AuthType.google,
      email: _currentUser.email,
      name: _currentUser?.displayName,
    );
    var result = await _authApi.signIn(credential);
    if (result.isError) {
      _googleSignIn.disconnect();
      return Result.error(result.asError.error);
    }
    return Result.value(
      AuthUserInfo(
        token: Token(value: result.asValue?.value),
        name: _currentUser.displayName,
        email: _currentUser.email,
        profileImg: _currentUser.photoUrl,
      ),
    );
  }

  @override
  Future<Result<bool>> signOut(String token) async {
    var res = await _authApi.signout(token);
    if (res.asValue.value) _googleSignIn.disconnect();
    return res;
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (e) {
      return;
    }
  }
}
