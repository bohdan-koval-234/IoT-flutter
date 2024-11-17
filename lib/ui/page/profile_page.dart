import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/ui/blocs/auth/auth_bloc.dart';
import 'package:labs/ui/widgets/logout_confirmation_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            emailController.text = state.user.email;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',),
                    radius: 50,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _updateProfile(context,
                        emailController.text,),
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      showLogoutConfirmationDialog(context, () {
                        context.read<AuthBloc>().add(LoggedOut());
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false,);
                      });
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _updateProfile(BuildContext context, String email) async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is Authenticated) {
      final user = (authBloc.state as Authenticated).user
          .copyWith(email: email);
      await authBloc.userService.setCurrentUser(user);
      authBloc.add(LoggedIn(user));
    }
  }
}
