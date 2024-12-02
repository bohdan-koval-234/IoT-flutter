import 'package:labs/entity/user.dart';

abstract class CurrentUserRepository {
  Future<User?> getCurrentUser();
  Future<void> saveCurrentUser(User user);
  Future<void> removeCurrentUser();
}
