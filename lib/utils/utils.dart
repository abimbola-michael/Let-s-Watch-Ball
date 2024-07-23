import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:timezone/data/latest.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/extensions.dart';

import '../main.dart';
import '../shared/models/list_change.dart';

String myId = FirebaseAuth.instance.currentUser?.uid ?? "";
bool isWindows = !kIsWeb && Platform.isWindows;
double statusBarHeight = window.padding.top / window.devicePixelRatio;
String timeNow = DateTime.now().toDateTimeString;

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

// String getFullTime(DateTime date) {
//   return DateFormat("h:ma").format(date);
// }
String getFullDate(DateTime date) {
  return DateFormat("dd/MM/yyyy").format(date);
}

String getFullTime(DateTime date) {
  return DateFormat("hh:mm a").format(date);
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

String getDateTime(String date, String time) {
  return "$date $time";
}
// DateTime getDateTime(String date, String time) {
//   final format =
//       time.toLowerCase().contains("am") || time.toLowerCase().contains("pm")
//           ? "dd/MM/yyyy hh:mm a"
//           : "dd/MM/yyyy hh:mm";
//   return DateFormat(format).parse("$date $time", true);
// }

String bestMatchTimeZone(DateTime parsedDateTime) {
  // Get all available time zones
  final allTimeZones = timeZoneDatabase.locations.keys;

  // Variable to store the best match time zone
  String bestMatchTimeZone = "";
  Duration smallestDifference = const Duration(hours: 24);

  // Compare the parsed DateTime with the current time in each time zone
  for (var timeZone in allTimeZones) {
    final location = getLocation(timeZone);
    final tzDateTime = TZDateTime.from(parsedDateTime, location);

    // Get the current time in the target time zone
    final nowInTz = TZDateTime.now(location);

    // Calculate the difference
    final difference = nowInTz.difference(tzDateTime).abs();

    // Find the smallest difference
    if (difference < smallestDifference) {
      smallestDifference = difference;
      bestMatchTimeZone = timeZone;
    }
  }
  return bestMatchTimeZone;
}

List<String> getTimeZoneDateTime(LiveMatch match) {
  String date = match.date;
  String time = match.time;

  final format =
      time.toLowerCase().contains("am") || time.toLowerCase().contains("pm")
          ? "dd/MM/yyyy hh:mm a"
          : "dd/MM/yyyy hh:mm";
  final sourceDateTime = DateFormat(format).parse("$date $time", true);
  // Get the current local time zone offset in hours
  final currentTimeZoneOffset = DateTime.now().timeZoneOffset;
  final hoursOffset = currentTimeZoneOffset.inHours;
  final minutesOffset = currentTimeZoneOffset.inMinutes.remainder(60);

  // Source GMT offset (Asia/Yangon) = +6:30
  const sourceOffset = Duration(hours: 6, minutes: 30);

  // Target GMT offset (assume your current local time zone, e.g., GMT+2)
  final targetOffset = Duration(minutes: (hoursOffset * 60) + minutesOffset);

  // Calculate the difference between source and target offsets
  final offsetDifference = targetOffset - sourceOffset;

  // Adjust the parsed date-time by the offset difference
  final localDateTime = sourceDateTime.add(offsetDifference);

  return [
    DateFormat("dd/MM/yyyy").format(localDateTime),
    DateFormat("hh:mm a").format(localDateTime)
  ];
}

// List<String> getTimeZoneDateTime(LiveMatch match) {
//   String date = match.date;
//   String time = match.time;
//   // String sourceTimeZone = "Asia/Yangon";

//   //String sourceTimeZone = "America/Detroit";
//   String sourceTimeZone = "Asia/Seoul";

//   final sourceDateTime =
//       DateFormat("dd/MM/yyyy hh:mm a").parse("$date $time", true);
//   // if (currentTimeZone == null) {
//   //   return [date, time];
//   // }
//   // String sourceTimeZone = bestMatchTimeZone(sourceDateTime);
//   // print("sourceTimeZone = $sourceTimeZone");
//   //final sourceLocation = getLocation(sourceTimeZone);

//   // final sourceLocation = Location(
//   //   'Custom/AsiaYangon',
//   //   [0],
//   //   [0],
//   //   const [
//   //     TimeZone(
//   //       6 * 3600 + 1800, // Offset in seconds (6 hours and 30 minutes)
//   //       isDst: false,
//   //       abbreviation: 'MMT',
//   //     )
//   //   ],
//   // );

//   // // Create a location for the local time zone
//   // final localLocation = Location(
//   //   'Custom/Local',
//   //   [0],
//   //   [0],
//   //   [
//   //     TimeZone(
//   //       hoursOffset * 3600 + minutesOffset * 60,
//   //       isDst: DateTime.now().isUtc ? false : true,
//   //       abbreviation: 'Local',
//   //     )
//   //   ],
//   // );

//   // final sourceTzDateTime = TZDateTime.from(sourceDateTime, sourceLocation);

//   // // final localDateTime = sourceTzDateTime.toLocal();
//   // //final localDateTime = TZDateTime.now(local);

//   // // Convert the source time zone date-time to the local time zone
//   // final localDateTime = TZDateTime.from(sourceTzDateTime, localLocation);
//   // print(
//   //     "location = $sourceLocation, local = $localLocation, hoursOffset = $hoursOffset:$minutesOffset, sourceTzDateTime = $sourceTzDateTime, $sourceDateTime, $localDateTime");

//   // Get the current local time zone offset in hours
//   final currentTimeZoneOffset = DateTime.now().timeZoneOffset;
//   final hoursOffset = currentTimeZoneOffset.inHours;
//   final minutesOffset = currentTimeZoneOffset.inMinutes.remainder(60);

//   // Source GMT offset (Asia/Yangon) = +6:30
//   const sourceOffset = Duration(hours: 6, minutes: 30);

//   // Target GMT offset (assume your current local time zone, e.g., GMT+2)
//   final targetOffset = Duration(minutes: (hoursOffset * 60) + minutesOffset);

//   // Calculate the difference between source and target offsets
//   final offsetDifference = targetOffset - sourceOffset;

//   // Adjust the parsed date-time by the offset difference
//   final localDateTime = sourceDateTime.add(offsetDifference);

//   return [
//     DateFormat("dd/MM/yyyy").format(localDateTime),
//     DateFormat("hh:mm a").format(localDateTime)
//   ];
// }
List<ListChange<T>> getListChanges<T>(
    List<T> oldList, List<T> newList, String Function(T t) keyCallback) {
  List<ListChange<T>> result = [];
  // newList.sort((a, b) => keyCallback(a).compareTo(keyCallback(b)));
  // oldList.sort((a, b) => keyCallback(a).compareTo(keyCallback(b)));
  Map<String, List> newMap = {};
  Map<String, List> oldMap = {};

  final length =
      newList.length > oldList.length ? newList.length : oldList.length;
  for (int i = 0; i < length; i++) {
    if (i < oldList.length) {
      final oldValue = oldList[i];
      oldMap[keyCallback(oldValue)] = [i, oldValue];
    }
    if (i < newList.length) {
      final newValue = newList[i];
      newMap[keyCallback(newValue)] = [i, newValue];
    }
  }
  for (var entry in newMap.entries) {
    final key = entry.key;
    final newResult = entry.value;
    final oldResult = oldMap[key];

    if (oldResult == null) {
      result.add(
        ListChange(
          index: newResult[0],
          oldIndex: -1,
          type: ListChangeType.added,
          value: newResult[1],
        ),
      );
    } else {
      // final newValue = newResult[1];
      // final oldValue = oldResult[1];

      if (newResult[1] != oldResult[1]) {
        result.add(
          ListChange(
            index: newResult[0],
            oldIndex: oldResult[0],
            type: ListChangeType.modified,
            value: newResult[1],
            oldValue: oldResult[1],
          ),
        );
      }

      oldMap.remove(key);
    }
  }
  for (var entry in oldMap.entries) {
    final oldResult = entry.value;
    result.add(
      ListChange(
        index: oldResult[0],
        oldIndex: oldResult[0],
        type: ListChangeType.removed,
        value: oldResult[1],
        oldValue: oldResult[1],
      ),
    );
  }

  return result;
}
