import 'package:flutter/material.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class FmLogo extends StatelessWidget {
  const FmLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "F",
            style: GoogleFonts.concertOne(
                fontSize: 26, fontWeight: FontWeight.w900, color: primaryColor),
          ),
          TextSpan(
            text: "M",
            style: GoogleFonts.concertOne(
                fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ])),

        // Text(
        //   "F",
        //   style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900),
        // ),
        // Text(
        //   "M",
        //   style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900),
        // )
      ],
    );
  }
}
