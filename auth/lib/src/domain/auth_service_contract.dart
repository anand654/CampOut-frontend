import 'package:async/async.dart';
import 'package:auth/src/domain/auth_user_info.dart';

abstract class IAuthService {
  Future<Result<AuthUserInfo>> signIn();
  Future<Result<bool>> signOut(String token);
}
