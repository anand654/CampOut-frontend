import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:me_and_my_tent_client/cache/local_store_contract.dart';
import 'package:me_and_my_tent_client/composition.dart';
import 'package:me_and_my_tent_client/models/user.dart';

enum AuthState { loading, signedIn, signedOut, error }

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final IAuthApi _authApi =
      AuthApi('base-url', Composition.httpClient);
  IAuthService _authService;

  AuthProvider() {
    _authService = GoogleAuth(this._authApi, this._googleSignIn);
  }
  final ILocalStore _localStore = Composition.localStore;

  AuthState _authState = AuthState.signedOut;
  User _user;

  // getters
  AuthState get authState => _authState;
  User get user => _user;
  //setters
  set authStateSet(AuthState data) {
    _authState = data;
    notifyListeners();
  }

  set userSet(User data) {
    _user = data;
  }

  Future<void> initialAuthState() async {
    final token = await _localStore.fetchtoken();
    if (token == null) {
      authStateSet = AuthState.signedOut;
      return;
    }
    final result = await _authApi.signInState(token.value);
    if (result.asValue.value || result.isError) {
      final _userinfo = await _localStore.fetchUserInfo();
      userSet = User(
        name: _userinfo[0],
        email: _userinfo[1],
        profileImg: _userinfo[2],
      );
      authStateSet = AuthState.signedIn;
      return;
    } else {
      await _localStore.delete();
      authStateSet = AuthState.signedOut;
    }
  }

  Future signIn() async {
    final result = await _authService.signIn();
    if (result.isError) return;
    await _localStore.save(result.asValue.value);
    userSet = User(
      name: result.asValue.value.name,
      email: result.asValue.value.email,
      profileImg: result.asValue.value.profileImg,
    );
    authStateSet = AuthState.signedIn;
    return;
  }

  Future signOut() async {
    final token = await _localStore.fetchtoken();
    final result = await _authService.signOut(token.value);
    if (result.asValue.value) {
      await _localStore.delete();
      authStateSet = AuthState.signedOut;
    } else {
      authStateSet = AuthState.signedIn;
    }
  }
}
