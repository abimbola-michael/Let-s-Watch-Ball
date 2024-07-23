// creating extension in flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../shared/components/app_bottom_sheet.dart';
import '../firebase/firestore_methods.dart';
import '../theme/colors.dart';

extension ListExtensions<T> on List<T> {
  List<List<T>> getGroupedList(String Function(T value) callback) {
    Map<String, int> idMap = {};
    List<List<T>> result = [];
    for (int i = 0; i < length; i++) {
      final value = this[i];
      final id = callback(value);
      final index = idMap[id];
      if (index == null) {
        idMap[id] = result.length;
        result.add([value]);
      } else {
        result[index].add(value);
      }
    }
    return result;
  }
}

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
  bool get isPortrait => width < height;
  bool get isLandscape => width > height;
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

  Future showSnackBar(String message, [bool isError = true]) async {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(
          message,
          style: bodySmall?.copyWith(color: white),
        ),
        backgroundColor: isError ? Colors.red : primaryColor));
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

extension DateTimeExtensions on DateTime {
  String get toDateTimeString => millisecondsSinceEpoch.toString();
}

extension StringExtensions on String {
  String get toJpg => "assets/images/png/$this.jpg";
  String get toPng => "assets/images/png/$this.png";
  String get toSvg => "assets/images/svg/$this.svg";
  DateTime get toDateTime => DateTime.fromMillisecondsSinceEpoch(toInt);
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

extension DocsnapshotExtension<T> on DocumentSnapshot {
  Map<String, dynamic>? get map =>
      data() != null ? data() as Map<String, dynamic> : null;
  T? getValue<T>(T Function(Map<String, dynamic> map) callback) =>
      map != null ? callback(map!) : null;
}

extension QuerysnapshotExtension<T> on QuerySnapshot {
  List<T> getValues<T>(T Function(Map<String, dynamic> map) callback) =>
      docs.isNotEmpty ? docs.map((doc) => callback(doc.map!)).toList() : [];
  List<ValueChange<T>> getValuesChange<T>(
          T Function(Map<String, dynamic> map) callback) =>
      docChanges.isNotEmpty
          ? docChanges
              .map((change) => ValueChange<T>(
                    type: change.type,
                    oldIndex: change.oldIndex,
                    newIndex: change.newIndex,
                    value: callback(change.doc.map!),
                  ))
              .toList()
          : [];
}

extension QueryExtension on Query {
  Query getQuery(List<dynamic>? where, List<dynamic>? order,
      List<dynamic>? start, List<dynamic>? end, List<dynamic>? limit) {
    Query query = this;
    if (where != null) {
      int times = (where.length / 3).floor();
      for (int i = 0; i < times; i++) {
        final j = i * 3;
        String name = where[j + 0];
        String clause = where[j + 1];
        dynamic value = where[j + 2];
        query = query.where(
          name,
          isEqualTo: clause == "==" ? value : null,
          isNotEqualTo: clause == "!=" ? value : null,
          isLessThan: clause == "<" ? value : null,
          isGreaterThan: clause == ">" ? value : null,
          isLessThanOrEqualTo: clause == "<=" ? value : null,
          isGreaterThanOrEqualTo: clause == ">=" ? value : null,
          whereIn: clause == "in" ? value : null,
          whereNotIn: clause == "notin" ? value : null,
          arrayContains: clause == "contains" ? value : null,
          arrayContainsAny: clause == "containsany" ? value : null,
          isNull: clause == "is" ? value : null,
        );
      }
    }
    if (order != null) {
      String orderName = order[0];
      bool desc = order[1] ?? false;
      query = query.orderBy(orderName, descending: desc);
    }
    if (start != null) {
      dynamic startName = start[0];
      bool after = start.length == 1 ? false : start[1];
      query =
          after ? query.startAfter([startName]) : query.startAt([startName]);
    }
    if (end != null) {
      dynamic endName = end[0];
      bool before = end.length == 1 ? false : end[1];
      query = before ? query.endBefore([endName]) : query.endAt([endName]);
    }
    if (limit != null) {
      int limitCount = limit[0];
      bool last = limit.length == 1 ? false : limit[1];
      query = last ? query.limitToLast(limitCount) : query.limit(limitCount);
    }
    return query;
  }
}

extension ValueChangeExtensions<T> on ValueChange<T> {
  bool get added => type == DocumentChangeType.added;
  bool get modified => type == DocumentChangeType.modified;
  bool get removed => type == DocumentChangeType.removed;
}

extension ListValueChangeExtensions<T> on List<ValueChange<T>> {
  void getValueChange(void Function(ValueChange<T> change)? changeCallback,
      {String Function(T value)? createdAtCallback,
      String Function(T value)? modifiedAtCallback,
      String? Function(T value)? deletedAtCallback}) {
    for (int i = 0; i < length; i++) {
      ValueChange<T> change = this[i];
      final type = change.type;
      final value = change.value;
      final createdAt = createdAtCallback?.call(value);
      final modifiedAt = modifiedAtCallback?.call(value);
      final deletedAt = deletedAtCallback?.call(value);
      DocumentChangeType newType = DocumentChangeType.added;

      if ((modifiedAt != null &&
              createdAt != null &&
              modifiedAt == createdAt) ||
          type == DocumentChangeType.added) {
        newType = DocumentChangeType.added;
      } else if (deletedAt != null || type == DocumentChangeType.removed) {
        newType = DocumentChangeType.removed;
      } else {
        newType = DocumentChangeType.modified;
      }
      change = ValueChange(
          value: value,
          type: newType,
          oldIndex: change.oldIndex,
          newIndex: change.newIndex);
      changeCallback?.call(change);
    }
  }

  void mergeResult(List<T> prevList, String Function(T value) idCallback,
      {void Function(ValueChange<T> change)? changeCallback,
      String Function(T value)? createdAtCallback,
      String Function(T value)? modifiedAtCallback,
      String? Function(T value)? deletedAtCallback}) {
    for (int i = 0; i < length; i++) {
      ValueChange<T> change = this[i];
      final type = change.type;
      final value = change.value;
      final createdAt = createdAtCallback?.call(value);
      final modifiedAt = modifiedAtCallback?.call(value);
      final deletedAt = deletedAtCallback?.call(value);
      DocumentChangeType newType = DocumentChangeType.added;

      if ((modifiedAt != null &&
              createdAt != null &&
              modifiedAt == createdAt) ||
          type == DocumentChangeType.added) {
        prevList.add(value);
        newType = DocumentChangeType.added;
      } else if (deletedAt != null || type == DocumentChangeType.removed) {
        prevList.removeWhere(
            (prevValue) => idCallback(prevValue) == idCallback(value));
        newType = DocumentChangeType.removed;
      } else {
        final index = prevList.indexWhere(
            (prevValue) => idCallback(prevValue) == idCallback(value));
        if (index != -1) {
          prevList[index] = value;
        }
        newType = DocumentChangeType.modified;
      }
      change = ValueChange(
          value: value,
          type: newType,
          oldIndex: change.oldIndex,
          newIndex: change.newIndex);
      changeCallback?.call(change);
    }
  }
}


// extension CollectionReferenceExtension on CollectionReference {
//   Query getQuery(List<dynamic>? where, List<dynamic>? order,
//       List<dynamic>? start, List<dynamic>? end, List<dynamic>? limit) {
//     Query query = this;
//     if (where != null) {
//       int times = (where.length / 3).floor();
//       for (int i = 0; i < times; i++) {
//         final j = i * 3;
//         String name = where[j + 0];
//         String clause = where[j + 1];
//         dynamic value = where[j + 2];
//         query = query.where(
//           name,
//           isEqualTo: clause == "==" ? value : null,
//           isNotEqualTo: clause == "!=" ? value : null,
//           isLessThan: clause == "<" ? value : null,
//           isGreaterThan: clause == ">" ? value : null,
//           isLessThanOrEqualTo: clause == "<=" ? value : null,
//           isGreaterThanOrEqualTo: clause == ">=" ? value : null,
//           whereIn: clause == "in" ? value : null,
//           whereNotIn: clause == "notin" ? value : null,
//           arrayContains: clause == "contains" ? value : null,
//           arrayContainsAny: clause == "containsany" ? value : null,
//           isNull: clause == "null" ? value : null,
//         );
//       }
//     }
//     if (order != null) {
//       String orderName = order[0];
//       bool desc = order[1] ?? false;
//       query = query.orderBy(orderName, descending: desc);
//     }
//     if (start != null) {
//       dynamic startName = start[0];
//       bool after = start.length == 1 ? false : start[1];
//       query =
//           after ? query.startAfter([startName]) : query.startAt([startName]);
//     }
//     if (end != null) {
//       dynamic endName = end[0];
//       bool before = end.length == 1 ? false : end[1];
//       query = before ? query.endBefore([endName]) : query.endAt([endName]);
//     }
//     if (limit != null) {
//       int limitCount = limit[0];
//       bool last = limit.length == 1 ? false : limit[1];
//       query = last ? query.limitToLast(limitCount) : query.limit(limitCount);
//     }
//     return query;
//   }
// }
