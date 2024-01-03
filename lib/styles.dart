import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const USER_IMG =
    'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODF8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8fDB8fHww';
const USER_NAME = "Rafi Putra";
const USER_EMAIL = "kelompokd2iot@gmail.com";
const USER_PASSWD = "petfeeder";
const PET_NAME = "Pablo";
const PET_BREED = "Persian";
const HAS_LOGGED_IN = "has_logged_in";

const primaryColorDark = Color(0xFF406338);
const accentColor = Color(0xFF6BA35D);
const primaryColor = Color(0xFF6BA35D);
const blackColor = Color(0xFF333333);

Future showModalSheet(context, height, child) async {
  final rsp = await showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h))),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              height: height, padding: EdgeInsets.all(2.h), child: child),
        ),
      );
    },
  );

  return rsp;
}

showConfirmationDialog(BuildContext context, String title, String msg) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: MyText(
          title,
          weight: FontWeight.w600,
          size: 18,
        ),
        content: MyText(
          msg,
          maxLines: 4,
        ),
        actions: <Widget>[
          TextButton(
            child: MyText(
              'Cancel',
              color: primaryColor,
            ),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, elevation: 0),
            child: MyText(
              'Yes',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );

  return result != null && result;
}

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    super.key,
    this.size,
    this.weight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isItalic,
  });
  final String data;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? isItalic;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.poppins(
          fontSize: size ?? 14,
          fontWeight: weight ?? FontWeight.normal,
          color: color ?? blackColor,
          fontStyle: isItalic ?? false ? FontStyle.italic : FontStyle.normal),
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: overflow,
    );
  }
}

class FillButton extends StatelessWidget {
  const FillButton(
      {super.key,
      this.width,
      required this.onClick,
      required this.label,
      this.background});
  final double? width;
  final Function() onClick;
  final String label;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(2.h),
              backgroundColor: background ?? primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.h))),
          child: MyText(
            label,
            weight: FontWeight.w600,
            color: Colors.white,
          )),
    );
  }
}

class OutlineButton extends StatelessWidget {
  const OutlineButton(
      {super.key,
      this.width,
      required this.onClick,
      required this.label,
      required this.color});
  final double? width;
  final Function() onClick;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: OutlinedButton(
          onPressed: onClick,
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(2.h),
              side: BorderSide(
                  color: color.withOpacity(0.7),
                  style: BorderStyle.solid,
                  width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.h),
              )),
          child: MyText(
            label,
            color: color,
            weight: FontWeight.w600,
          )),
    );
  }
}
