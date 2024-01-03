import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pet_feeder_v2/screens/landing_screen.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FragmentProfile extends StatefulWidget {
  const FragmentProfile({super.key});

  @override
  State<FragmentProfile> createState() => _FragmentProfileState();
}

class _FragmentProfileState extends State<FragmentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 8.h),
        children: [
          MyText(
            'Profile',
            size: 24,
            weight: FontWeight.w500,
          ),
          SizedBox(
            height: 4.h,
          ),
          profileImage(80, USER_IMG),
          SizedBox(
            height: 4.h,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: primaryColor.withOpacity(0.3),
            ),
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 2.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText('Name'),
                        MyText(
                          USER_NAME,
                          size: 16,
                          weight: FontWeight.w500,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(Icons.mail),
                    SizedBox(
                      width: 2.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText('Email'),
                        MyText(
                          USER_EMAIL,
                          size: 16,
                          weight: FontWeight.w500,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(Icons.pets),
                    SizedBox(
                      width: 2.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText('Pet Name'),
                        MyText(
                          PET_NAME,
                          size: 16,
                          weight: FontWeight.w500,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(Icons.pets),
                    SizedBox(
                      width: 2.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText('Pet Breed'),
                        MyText(
                          PET_BREED,
                          size: 16,
                          weight: FontWeight.w500,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          FillButton(
              onClick: () {
                showConfirmationDialog(context, 'Sign Out',
                        'Are you sure you want to sign out?')
                    .then((value) async {
                  if (value) {
                    EasyLoading.show(status: 'Signing out..');
                    await Future.delayed(Duration(seconds: 1));
                    final pref = await SharedPreferences.getInstance();

                    pref.setBool(HAS_LOGGED_IN, false);
                    EasyLoading.dismiss();

                    pushNewScreen(context,
                        screen: LandingScreen(), withNavBar: false);

                    // Navigator.of(context).pushAndRemoveUntil(
                        
                    //     MaterialPageRoute(builder: (_) => LandingScreen()),
                    //     (route) => false);
                  }
                });
              },
              label: 'Sign Out')
        ],
      ),
    );
  }

  Widget profileImage(double sizeRadius, String linkImage) => CircleAvatar(
        radius: sizeRadius,
        backgroundColor: Colors.black,
        child: ClipOval(
          child: Image.network(
            linkImage,
            fit: BoxFit.cover,
            width: sizeRadius * 2,
            height: sizeRadius * 2,
          ),
        ),
      );
}
