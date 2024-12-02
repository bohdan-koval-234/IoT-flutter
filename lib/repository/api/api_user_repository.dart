import 'package:labs/entity/user.dart';
import 'package:labs/repository/user_repository.dart';
import 'package:labs/service/api/user_api_service.dart';

class ApiUserRepository extends UserRepository {
  final UserApiService userApiService;
  static final ApiUserRepository _instance = ApiUserRepository
      ._internal(UserApiService());

  factory ApiUserRepository() {
    return _instance;
  }

  ApiUserRepository._internal(this.userApiService);

  @override
  Future<void> add(User user) async {
    await userApiService.createUser(user);
  }

  @override
  Future<List<User>> get() async {
    return await userApiService.getAllUsers();
  }

  @override
  Future<User?> getUser(String email) async {
    return await userApiService.getUserByEmail(email);
  }
}