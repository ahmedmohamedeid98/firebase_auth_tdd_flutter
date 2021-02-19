import 'package:firebase_auth_tdd_flutter/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/presentation/pages/shared_widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: RoundedButton(
            text: 'LOGOUT',
            press: () {
              BlocProvider.of<AuthenticationBloc>(context).add(Logout());
            }),
      ),
    );
  }
}
