// creating extension in flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/reuseable/app_bottom_sheet.dart';

extension IntExtensions on int {
  ///returns a String with leading zeros.
  ///1 would be with the [numberOfTotalDigits] = 3 lead to a string '001'
  String addLeadingZeros(int numberOfTotalDigits) =>
      toString().padLeft(numberOfTotalDigits, '0');

  String get toMinsOrSecs {
    return this <= 60 ? "$this Secs" : "${this ~/ 60} Mins";
  }
}

extension ContextExtension on BuildContext {
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  ThemeData get theme => Theme.of(this);
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double figmaHeight(double figmaHeight) =>
      figmaHeight * height / 812; //812 is the figma height
  double figmaWidth(double figmaWidth) =>
      figmaWidth * width / 375; //375 is the figma width
  double heightPercent(double percent, [double? subtract]) =>
      (height - (subtract ?? 0)) * percent / 100;
  double widthPercent(double percent, [double? subtract]) =>
      (width - (subtract ?? 0)) * percent / 100;
  Color? get iconColor => Theme.of(this).iconTheme.color;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;
  Future pushTo(Widget page) =>
      Navigator.of(this).push(MaterialPageRoute(builder: (context) => page));
  Future pushNamedTo(String routeName, {Object? args}) =>
      Navigator.of(this).pushNamed(routeName, arguments: args);
  Future pushAndPop(Widget page, [result]) => Navigator.of(this)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
  Future pushNamedAndPop(String routeName, {Object? args}) =>
      Navigator.of(this).pushReplacementNamed(routeName, arguments: args);
  pop([result]) => Navigator.of(this).pop(result);
  popUntil(String routeName) =>
      Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  Future pushReplacementTo(Widget page) => Navigator.of(this)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));

  get args => ModalRoute.of(this)?.settings.arguments;
  Future showAppBottomSheet(WidgetBuilder builder) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: this,
      builder: (context) => AppBottomSheet(child: builder(context)),
    );
  }

  Future showAppDialog(WidgetBuilder builder) {
    return showDialog(
      context: this,
      builder: builder,
    );
  }

  Future showAlertDialog(WidgetBuilder builder) {
    return showDialog(
      context: this,
      builder: builder,
    );
  }

  // void showComfirmationSnackbar(String message) {
  //   ScaffoldMessenger.of(this).showSnackBar(
  //     SnackBar(
  //       content: Text(message, style: bodySmall?.copyWith(color: Colors.white)),
  //       //behavior: SnackBarBehavior.floating,
  //       backgroundColor: grey.withOpacity(0.95),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //   );
  // }
}

extension StringExtensions on String {
  String get toJpg => "assets/images/png/$this.jpg";
  String get toPng => "assets/images/png/$this.png";
  String get toSvg => "assets/images/svg/$this.svg";
  String lastChars(int n) => substring(length - n);

  String get capitalize {
    if (isEmpty) return "";
    return this[0].toUpperCase() +
        (length == 1 ? "" : substring(1).toLowerCase());
  }

  String get toValidTime {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(this);
    String formattedTime = DateFormat('h:mma').format(parsedTime).toLowerCase();
    return formattedTime;
  }

  double get toDouble {
    if (double.tryParse(this) != null) {
      return double.parse(this);
    } else if (int.tryParse(this) != null) {
      return int.parse(this).toDouble();
    } else {
      return 0;
    }
  }

  int get toInt {
    if (int.tryParse(this) != null) {
      return int.parse(this);
    } else if (double.tryParse(this) != null) {
      return double.parse(this).toInt();
    } else {
      return 0;
    }
  }

  Color get toColor {
    String string = this;
    if (startsWith("rgb")) {
      string = toHex;
    }
    return Color(
        "0xFF${string.isEmpty ? "" : string.substring(string.indexOf("#") + 1)}"
            .toInt);
  }

  String get toHex {
    final openIndex = indexOf("(");
    final closeIndex = indexOf(")");
    if (openIndex == -1 || closeIndex == -1) return "";
    final detailsString = substring(openIndex + 1, closeIndex);
    final details = detailsString.split(", ");
    int r = details[0].toInt;
    int g = details[1].toInt;
    int b = details[2].toInt;
    double opacity = details.length < 4 ? 0 : details[3].toDouble;
    int opacityHex = (opacity * 255).round();
    return '#${opacityHex.toRadixString(16).padLeft(2, '0')}${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}

extension DoubleExtensions on double {
  double get toPrecision => double.parse(toStringAsFixed(2));
  String toCurrency(String currency) =>
      NumberFormat.currency(locale: 'en_US', symbol: currency).format(this);
  String get toTime => DateFormat('hh:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(toInt()));
}

extension IntExtenstions on int {
  String toTime() =>
      DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(this));
  String toCurrency(String currency) =>
      NumberFormat.currency(locale: 'en_US', symbol: currency).format(this);
}
