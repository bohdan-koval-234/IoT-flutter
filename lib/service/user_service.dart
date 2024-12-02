import 'package:labs/entity/user.dart';
import 'package:labs/repository/api/api_user_repository.dart';
import 'package:labs/repository/current_user_repository.dart';
import 'package:labs/repository/shared/prefs/shared_prefs_current_user_repository.dart';
import 'package:labs/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  late final UserRepository _userRepository;
  late final CurrentUserRepository currentUserRepository;

  factory UserService(UserRepository userRepository) {
    return _instance;
  }

  UserService._internal();

  static Future<UserService> initialize() async {
    final userRepository = ApiUserRepository();
    final prefs = await SharedPreferences.getInstance();
    final currentUserRepository = SharedPrefsCurrentUserRepository(prefs);

    _instance._userRepository = userRepository;
    _instance.currentUserRepository = currentUserRepository;

    return _instance;
  }

  Future<bool> login(String email, String password) async {
    final users = await _userRepository.get();
    for (var user in users) {
      if (user.email == email && user.password == password) {
        await setCurrentUser(user);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    final newUser = User(const Uuid().v4(), email, password);

    if (await getUser(email) != null) {
      return false;
    }

    await setCurrentUser(newUser);
    await _userRepository.add(newUser);

    return true;
  }

  Future<User?> getUser(String email) async {
    return await _userRepository.getUser(email);
  }

  Future<User?> getCurrentUser() async {
    return await currentUserRepository.getCurrentUser();
  }

  Future<void> setCurrentUser(User user) async {
    await currentUserRepository.saveCurrentUser(user);
  }

  Future<void> logout() async {
    await currentUserRepository.removeCurrentUser();
  }
}
