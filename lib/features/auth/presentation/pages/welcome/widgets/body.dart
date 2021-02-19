import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../constants.dart';
import '../../../bloc/authentication_bloc.dart';
import '../../shared_widgets/rounded_button.dart';
import 'widgets.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'WELCOME TO FIREBASE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.035),
            SvgPicture.asset(
              'assets/icons/chat.svg',
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.055),
            RoundedButton(
              text: 'Login',
              press: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(NavigateToLogin());
              },
            ),
            RoundedButton(
              text: 'Sign Up',
              press: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(NavigateToSignUp());
              },
              color: kPrimaryLightColor,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
