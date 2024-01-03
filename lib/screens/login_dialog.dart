import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles.dart';

class LoginDialog extends StatelessWidget {
  LoginDialog({super.key});
  final _email = TextEditingController();
  final _pw = TextEditingController();

  final focusNodeE = FocusNode();
  final focusNodeP = FocusNode();

  void login(context) async {
    if (_email.text.isEmpty) {
      EasyLoading.showInfo('Silakan masukkan email');
      focusNodeE.requestFocus();
      return;
    }
    focusNodeE.unfocus();
    if (_pw.text.isEmpty) {
      EasyLoading.showInfo('Silakan masukkan password');
      focusNodeP.requestFocus();
      return;
    }
    focusNodeP.unfocus();

    if (_email.text != USER_EMAIL && _pw.text != USER_PASSWD) {
      Navigator.pop(context, false);
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          'Sign In',
          size: 20,
          weight: FontWeight.w500,
        ),
        SizedBox(
          height: 2.h,
        ),
        MyText(
          'Insert your credential to Sign In',
        ),
        SizedBox(
          height: 1.h,
        ),
        TextField(
          controller: _email,
          focusNode: focusNodeE,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.h),
              ),
              hintText: 'Email'),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextField(
          controller: _pw,
          focusNode: focusNodeP,
          obscureText: true,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.h),
              ),
              hintText: 'Password'),
        ),
        SizedBox(
          height: 2.h,
        ),
        FillButton(
            onClick: () {
              login(context);
            },
            label: 'Sign In',
            background: primaryColor)
      ],
    );
  }
}
