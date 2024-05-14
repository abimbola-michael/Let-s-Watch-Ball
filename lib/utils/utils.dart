import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../main.dart';

double statusBarHeight = window.padding.top / window.devicePixelRatio;

bool get isDarkMode =>
    sharedPreferences.getBool("darkmode") ??
    PlatformDispatcher.instance.platformBrightness == Brightness.dark;

bool isValidEmail(String email) {
  // Regular expression for validating an email address
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber, [int limit = 10]) {
  if (phoneNumber.length < limit) return false;
  // Regular expression for validating a generic phone number
  // final RegExp phoneRegex =
  //     RegExp(r'^[0-9]{10}$'); // Assuming 10-digit phone number format
  final RegExp phoneRegex = RegExp(r'^[0-9]'); //
  return phoneRegex.hasMatch(phoneNumber);
}

bool isValidName(String name) {
  // Check if the name is not empty
  if (name.isEmpty) {
    return false;
  }

  // Check if the name contains only alphabetic characters, spaces, or hyphens
  final RegExp nameRegex = RegExp(r'^[a-zA-Z\- ]+$');
  return nameRegex.hasMatch(name);
}

bool isValidPassword(String password) {
  // Check if password is at least 8 characters long
  if (password.length < 6) {
    return false;
  }

  // Check if password contains at least one uppercase letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  }

  // Check if password contains at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  }

  // Check if password contains at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  // Check if password contains at least one special character
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return false;
  }

  // If all criteria are met, return true
  return true;
}

bool hasValidLength(String input, int minLength, int maxLength) {
  final length = input.length;
  return length >= minLength && length <= maxLength;
}

bool isMobile() {
  return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

String durationToString(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  // if (duration.inHours > 0) {
  //   return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  // }
  return "$twoDigitMinutes:$twoDigitSeconds";
}

int stringToDuration(String durationString) {
  List<String> parts = durationString.split(":");
  if (parts.length > 3 || parts.isEmpty) {
    return -1;
  }
  if (parts.length == 1) {
    if (int.tryParse(parts[0]) == null && double.tryParse(parts[0]) == null) {
      return -1;
    }
    int seconds = double.tryParse(parts[0]) != null
        ? (double.parse(parts[0])).round()
        : int.parse(parts[0]);
    return seconds;
  }
  if (parts.length == 2) {
    if (int.tryParse(parts[0]) == null && double.tryParse(parts[0]) == null) {
      return -1;
    }
    if (int.tryParse(parts[1]) == null && double.tryParse(parts[1]) == null) {
      return -1;
    }
    int minutes = double.tryParse(parts[0]) != null
        ? (double.parse(parts[0])).round()
        : int.parse(parts[0]);
    int seconds = double.tryParse(parts[1]) != null
        ? (double.parse(parts[1])).round()
        : int.parse(parts[1]);
    return (minutes * 60) + seconds;
  }
  if (int.tryParse(parts[0]) == null && double.tryParse(parts[0]) == null) {
    return -1;
  }
  if (int.tryParse(parts[1]) == null && double.tryParse(parts[1]) == null) {
    return -1;
  }
  if (int.tryParse(parts[2]) == null && double.tryParse(parts[2]) == null) {
    return -1;
  }
  int hours = double.tryParse(parts[0]) != null
      ? (double.parse(parts[0])).round()
      : int.parse(parts[0]);
  int minutes = double.tryParse(parts[1]) != null
      ? (double.parse(parts[1])).round()
      : int.parse(parts[1]);
  int seconds = double.tryParse(parts[2]) != null
      ? (double.parse(parts[2])).round()
      : int.parse(parts[2]);
  return (hours * 3600) + (minutes * 60) + seconds;
}

// String getRelativeDate(DateTime date) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(date);
//   if (difference.inDays <= 0) {
//     return 'Today';
//   } else if (difference.inDays <= 1) {
//     return 'Yesterday';
//   } else if (difference.inDays <= 7) {
//     return 'Previous 7 days';
//   } else if (difference.inDays <= 30) {
//     return 'Previous 30 days';
//   } else {
//     return date.year.toString();
//   }
// }
String getCalDate(DateTime date) {
  DateTime now = DateTime.now();
  int yearDiff = date.year - now.year;

  int dayDiff = date.difference(now).inDays;
  if (dayDiff == 0 && date.day == now.day) {
    return 'Today';
  } else {
    return DateFormat("E d MMM${yearDiff > 0 ? " yyyy" : ""}").format(date);
    //return "${date.weekday} ${date.day} ${date.month}${difference.inDays > 365 ? " ${date.year}" : ""}";
  }
}

String getDate(DateTime date) {
  return DateFormat("d MMM").format(date);
}

String getTime(DateTime date) {
  return DateFormat("h:m").format(date);
}

String getFullTime(DateTime date) {
  return DateFormat("h:ma").format(date);
}
