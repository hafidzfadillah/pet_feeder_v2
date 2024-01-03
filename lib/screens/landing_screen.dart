import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_feeder_v2/screens/parent_screen.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_dialog.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 85.w,
                    height: 85.w,
                    child: Lottie.asset(
                      'assets/images/lottie_anim.json',
                    ),
                  ),
                  MyText(
                    'A tasty treat is on its way!',
                    weight: FontWeight.w500,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyText(
                    'Hopefully $PET_NAME has her bib ready.',
                    size: 16,
                  )
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.h),
              child: FillButton(
                label: 'Get Started',
                onClick: () {
                  _showLoginDialog(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(context) async {
    await showModalSheet(context, 45.h, LoginDialog()).then((value) async {
      if (value != null) {
        if (value) {
          EasyLoading.show(status: 'Memproses permintaan Anda..');
          await Future.delayed(Duration(seconds: 2));

          final pref = await SharedPreferences.getInstance();
          pref.setBool(HAS_LOGGED_IN, true);

          EasyLoading.showSuccess('Login Berhasil');
          await Future.delayed(Duration(seconds: 2));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ParentScreen()));
        } else {
          EasyLoading.show(status: 'Memproses permintaan Anda..');
          await Future.delayed(Duration(seconds: 2));
          EasyLoading.showError('Email/Password tidak dikenal');
        }
      }
    });
  }
}
