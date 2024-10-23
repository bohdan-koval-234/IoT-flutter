import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:labs/repository/shared/prefs/shared_prefs_current_user_repository.dart';
import 'package:labs/repository/shared/prefs/shared_prefs_user_repository.dart';
import 'package:labs/service/connectivity_service.dart';
import 'package:labs/service/user_service.dart';
import 'package:labs/ui/widgets/no_internet_dialog.dart';
import 'package:labs/ui/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SharedPrefsUserRepository? _userRepository;
  SharedPrefsCurrentUserRepository? _currentUserRepository;
  UserService? _userService;
  ConnectivityService? _connectivityService;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeServices();
    await _loadCurrentUser();
  }

  @override
  void dispose() {
    _connectivityService?.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userRepository = SharedPrefsUserRepository(prefs);
      _currentUserRepository = SharedPrefsCurrentUserRepository(prefs);
      _userService = UserService(_userRepository!, _currentUserRepository!);

      if (mounted) {
        _connectivityService = ConnectivityService(context);
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing services: $e');
      }
    }
  }

  Future<void> _loadCurrentUser() async {
    if (!mounted) return;

    final user = await _currentUserRepository!.getCurrentUser();
    final status = await _connectivityService?.getCurrentStatus();

    if (status == InternetStatus.disconnected && user != null && mounted) {
      showSuccessDialog(context, () {
        Navigator.pushNamed(context, '/home');
      }, 'No internet connection. Logging in with cached user data.'
          ' You need to connect to internet',);
      return;
    }

    if (user != null && mounted) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loginUser,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    final status = await _connectivityService?.getCurrentStatus();

    if (status == InternetStatus.disconnected && mounted) {
      showNoInternetDialog(context);
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isValid(email, password)) {
      await _attemptLogin(email, password);
    }
  }

  Future<void> _attemptLogin(String email, String password) async {
    try {
      final bool login = await _userService!.login(email, password);
      if (login && mounted) {
        _handleSuccessfulLogin();
      } else {
        _showLoginError();
      }
    } catch (e) {
      _showLoginError();
    }
  }

  void _handleSuccessfulLogin() {
    showSuccessDialog(context, () {
      Navigator.pushNamed(context, '/home');
    }, 'Login successful!',);
  }

  void _showLoginError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  bool _isValid(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return false;
    }

    return true;
  }
}
