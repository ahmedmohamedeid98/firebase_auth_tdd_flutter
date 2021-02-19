import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants.dart';
import '../../bloc/authentication_bloc.dart';
import '../shared_widgets/already_have_an_account_check.dart';
import '../shared_widgets/rounded_button.dart';
import '../shared_widgets/rounded_input_field.dart';
import '../shared_widgets/rounded_password_field.dart';
import 'widgets/or_divider.dart';
import 'widgets/signup_background.dart';
import 'widgets/social_icon.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController passController;
  final TextEditingController emailController;

  const SignUpPage({Key key, this.passController, this.emailController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: SignUpBackground(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                SvgPicture.asset(
                  'assets/icons/signup.svg',
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.02),
                RoundedInputField(
                  controller: emailController,
                  icon: Icons.person,
                  hintText: 'Your Email',
                ),
                RoundedPasswordField(
                  controller: passController,
                ),
                RoundedButton(
                    text: 'SIGNUP',
                    press: () {
                      if (passController.text.isNotEmpty &&
                          emailController.text.isNotEmpty) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          CreateAccountWithEmail(
                              email: emailController.text,
                              password: passController.text),
                        );
                      }
                    }),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(NavigateToLogin());
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      iconSrc: 'assets/icons/facebook.svg',
                      press: () {},
                    ),
                    SocialIcon(
                      iconSrc: 'assets/icons/twitter.svg',
                      press: () {},
                    ),
                    SocialIcon(
                      iconSrc: 'assets/icons/google-plus.svg',
                      press: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
