import 'package:auth/auth.dart';
import 'package:me_and_my_tent_client/cache/local_store_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TOKEN = 'CACHED_TOKEN';
const CACHED_USER = 'CACHED_USER';

class LocalStorage implements ILocalStore {
  final SharedPreferences _sharedPreferences;
  LocalStorage(this._sharedPreferences);

  @override
  Future<void> save(AuthUserInfo userInfo) async {
    await _sharedPreferences.setString(CACHED_TOKEN, userInfo.token.value);
    await _sharedPreferences.setStringList(
      CACHED_USER,
      [
        userInfo.name,
        userInfo.email,
        userInfo.profileImg,
      ],
    );
  }

  @override
  Future<void> delete() async {
    await _sharedPreferences.remove(CACHED_TOKEN);
    await _sharedPreferences.remove(CACHED_USER);
  }

  @override
  Future<Token> fetchtoken() async {
    final _tokenStr = _sharedPreferences.getString(CACHED_TOKEN);

    if (_tokenStr != null)
      return Token(
        value: _tokenStr
      );
    return null;
  }

  @override
  Future<List<String>> fetchUserInfo() async {
    final _userInfo = _sharedPreferences.getStringList(CACHED_USER);
    if (_userInfo != null) return _userInfo;
    return null;
  }
}
