import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants.dart';
import '../../bloc/authentication_bloc.dart';
import '../shared_widgets/already_have_an_account_check.dart';
import '../shared_widgets/rounded_button.dart';
import '../shared_widgets/rounded_input_field.dart';
import '../shared_widgets/rounded_password_field.dart';
import 'widgets/background.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController passController;
  final TextEditingController emailController;

  const LoginPage({Key key, this.passController, this.emailController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                'assets/icons/login.svg',
                width: size.width * 0.7,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                controller: emailController,
                icon: Icons.person,
                hintText: 'Your Email',
              ),
              RoundedPasswordField(
                controller: passController,
              ),
              RoundedButton(
                text: 'LOGIN',
                press: () {
                  if (passController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticatedWithEmail(
                        email: emailController.text,
                        password: passController.text,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(NavigateToSignUp());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
