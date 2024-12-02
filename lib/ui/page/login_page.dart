import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/ui/blocs/auth/auth_bloc.dart';
import 'package:labs/ui/widgets/success_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loginUser(context, emailController.text,
                  passwordController.text,),
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

  void _loginUser(
      BuildContext context, String email, String password,) async {
    // Perform validation
    if (!_isValid(email, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }

    final userService = context.read<AuthBloc>().userService;
    final bool login = await userService.login(email, password);

    if (login) {
      final user = await userService.getCurrentUser();

      if (context.mounted) {
        context.read<AuthBloc>().add(LoggedIn(user!));
        showSuccessDialog(
          context,
              () => Navigator.pushNamed(context, '/home'),
          'Login successful!',
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  bool _isValid(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
