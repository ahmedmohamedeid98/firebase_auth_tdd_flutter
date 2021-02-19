import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'features/auth/presentation/bloc/authentication_bloc.dart';
import 'features/auth/presentation/pages/home/home_page.dart';
import 'features/auth/presentation/pages/loading_page.dart';
import 'features/auth/presentation/pages/login/login_page.dart';
import 'features/auth/presentation/pages/signup/signup_page.dart';
import 'features/auth/presentation/pages/welcome/welcome_page.dart';
import 'injection_container.dart' as dependancyInjection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  dependancyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // i know that is bad to put text editing controller here
  // but i do this because i need to save last input data
  // for user to allow him editing it in failure cases
  final loginEmailCont = TextEditingController();
  final loginPassCont = TextEditingController();
  final signupEmailCont = TextEditingController();
  final signupPassCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isSignIN = true;

    return BlocProvider(
      create: (_) => dependancyInjection.sl<AuthenticationBloc>(),
      child: MaterialApp(
        title: 'Firebase Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is NewAccount) {
              isSignIN = false;
            } else if (state is Unauthenticated) {
              isSignIN = true;
            } else if (state is Error) {
              // show snack bar with error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          // builder can called more than one time when the state
          // changes so we use listener which called once when state
          // changes
          builder: (context, state) {
            if (state is Welcome) {
              return WelcomePage();
            } else if (state is Loading) {
              return LoadingPage();
            } else if (state is Unauthenticated) {
              return LoginPage(
                passController: loginPassCont,
                emailController: loginEmailCont,
              );
            } else if (state is NewAccount) {
              return SignUpPage(
                emailController: signupEmailCont,
                passController: signupPassCont,
              );
            } else if (state is Authenticated) {
              return HomePage();
            } else if (state is Error) {
              // in error state we come back to the last state
              // and in listener we show the error message to user
              return isSignIN
                  ? LoginPage(
                      passController: loginPassCont,
                      emailController: loginEmailCont,
                    )
                  : SignUpPage(
                      emailController: signupEmailCont,
                      passController: signupPassCont,
                    );
            } else {
              return Scaffold(
                body: Center(
                  child: Text('Something want wrong'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
