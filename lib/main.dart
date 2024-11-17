import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/service/subject_service.dart';
import 'package:labs/service/user_service.dart';
import 'package:labs/ui/blocs/auth/auth_bloc.dart';
import 'package:labs/ui/blocs/subjects/subject_bloc.dart';
import 'package:labs/ui/page/home_page.dart';
import 'package:labs/ui/page/login_page.dart';
import 'package:labs/ui/page/profile_page.dart';
import 'package:labs/ui/page/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userService = await UserService.initialize();
  final subjectService = await SubjectService.initialize();

  runApp(MyApp(
    userService: userService,
    subjectService: subjectService,
  ),);
}

class MyApp extends StatelessWidget {
  final UserService userService;
  final SubjectService subjectService;

  const MyApp({
    required this.userService, required this.subjectService, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(userService)..add(AppStarted()),
        ),
        BlocProvider<SubjectBloc>(
          create: (_) => SubjectBloc(subjectService),
        ),
      ],
      child: MaterialApp(
        title: 'Lab Tracker',
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            },
          ),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegistrationPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
