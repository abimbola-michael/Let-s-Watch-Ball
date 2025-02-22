import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/utils/extensions.dart';

class ValueChange<T> {
  final T value;
  final DocumentChangeType type;
  final int oldIndex;
  final int newIndex;

  ValueChange(
      {required this.value,
      required this.type,
      required this.oldIndex,
      required this.newIndex});
}

class FirestoreMethods {
  var myId = "";
  FirestoreMethods() {
    myId = AuthMethods().myId;
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference getCollectionRef(List<String> path) {
    return firestore.collection(path.join("/"));
  }

  Query getGroupCollectionRef(List<String> path) {
    return firestore.collectionGroup(path.join("/"));
  }

  DocumentReference getDocumentRef(List<String> path) {
    return firestore.doc(path.join("/"));
  }

  Query addWhereClauseToRef(CollectionReference ref, String where,
      String whereClause, dynamic whereValue) {
    switch (whereClause) {
      case "==":
        return ref.where(where, isEqualTo: whereValue);
      case "!=":
        return ref.where(where, isNotEqualTo: whereValue);

      case "<":
        return ref.where(where, isLessThan: whereValue);
      case "<=":
        return ref.where(where, isLessThanOrEqualTo: whereValue);
      case ">":
        return ref.where(where, isGreaterThan: whereValue);
      case ">=":
        return ref.where(where, isGreaterThanOrEqualTo: whereValue);
      case "in":
        return ref.where(where, whereIn: whereValue);
      case "not in":
        return ref.where(where, whereNotIn: whereValue);
      case "contain":
        return ref.where(where, arrayContains: whereValue);
      case "contain any":
        return ref.where(where, arrayContainsAny: whereValue);
      case "null":
        return ref.where(where, isNull: whereValue);
    }
    return ref;
  }

  Future<void> setValue(List<String> path,
      {required Map<String, dynamic> value, bool merge = false}) async {
    try {
      if (path.length.isOdd) {
        final ref = getCollectionRef(path);
        await ref.add(value);
        return;
      } else {
        final ref = getDocumentRef(path);
        return ref.set(value, merge ? SetOptions(merge: true) : null);
      }
    } on FirebaseException catch (e) {}
  }

  Future<void> setValues(List<String> path,
      {required List<Map<String, dynamic>> values, bool merge = false}) async {
    try {
      final batch = firestore.batch();
      for (int i = 0; i < values.length; i++) {
        final value = values[i];
        if (path.length.isOdd) {
          final ref = getCollectionRef(path);
          final id = getId(path);
          batch.set(ref.doc(id), value, merge ? SetOptions(merge: true) : null);
        } else {
          final ref = getDocumentRef(path);
          batch.set(ref, value, merge ? SetOptions(merge: true) : null);
        }
      }
      return batch.commit();
    } on FirebaseException catch (e) {}
  }

  Future<void> setValueIfNotExist(List<String> path,
      {required Map<String, dynamic> value, bool merge = false}) async {
    try {
      return firestore.runTransaction((transaction) async {
        final ref = getDocumentRef(path);
        final snapshot = await transaction.get(ref);
        if (!snapshot.exists) {
          transaction.set(ref, value, merge ? SetOptions(merge: true) : null);
        }
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> updateValue(List<String> path,
      {required Map<String, dynamic> value}) async {
    try {
      if (path.length.isOdd) {
        final ref = getCollectionRef(path);
        await ref.add(value);
        return;
      } else {
        final ref = getDocumentRef(path);
        return ref.update(value);
      }
    } on FirebaseException catch (e) {}
  }

  Future<void> updateValues(List<String> path,
      {required List<Map<String, dynamic>> values}) async {
    try {
      final batch = firestore.batch();
      for (int i = 0; i < values.length; i++) {
        final value = values[i];
        if (path.length.isOdd) {
          final ref = getCollectionRef(path);
          final id = getId(path);
          batch.update(ref.doc(id), value);
        } else {
          final ref = getDocumentRef(path);
          batch.update(ref, value);
        }
      }
      return batch.commit();
    } on FirebaseException catch (e) {}
  }

  Future<void> removeValue(List<String> path,
      {bool Function(Map? map)? callback,
      List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit}) async {
    try {
      if (path.length.isOdd) {
        final ref =
            getCollectionRef(path).getQuery(where, order, start, end, limit);
        final batch = firestore.batch();
        final snapshots = await ref.get();
        for (var doc in snapshots.docs) {
          if (callback != null) {
            if (callback(doc.map)) batch.delete(doc.reference);
          } else {
            batch.delete(doc.reference);
          }
        }
        return batch.commit();
      } else {
        final ref = getDocumentRef(path);
        return ref.delete();
      }
    } on FirebaseException catch (e) {}
  }

  Future<T?> getValue<T>(
      T Function(Map<String, dynamic> map) callback, List<String> path) async {
    try {
      if (path.length.isOdd) {
        final ref = getCollectionRef(path);
        final snapshot = await ref.get();
        return snapshot.getValues(callback).last;
      } else {
        final ref = getDocumentRef(path);
        final snapshot = await ref.get();
        return snapshot.getValue(callback);
      }
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<List<T>> getValues<T>(
      T Function(Map<String, dynamic> map) callback, List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async {
    try {
      if (path.length.isOdd) {
        final ref = isSubcollection
            ? getGroupCollectionRef(path)
                .getQuery(where, order, start, end, limit)
            : getCollectionRef(path).getQuery(where, order, start, end, limit);
        final snapshot = await ref.get();
        return snapshot.getValues(callback);
      } else {
        final ref = getDocumentRef(path);
        final snapshot = await ref.get();
        return snapshot.getValue(callback) != null
            ? [snapshot.getValue(callback)!]
            : [];
      }
    } on Exception catch (e) {
      return [];
    }
  }

  Stream<T?> getValueStream<T>(
      T Function(Map<String, dynamic> map) callback, List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async* {
    try {
      if (path.length.isOdd) {
        final ref = isSubcollection
            ? getGroupCollectionRef(path)
                .getQuery(where, order, start, end, limit)
            : getCollectionRef(path).getQuery(where, order, start, end, limit);
        final snapshots = ref.snapshots();
        yield* snapshots.map((snapshot) => snapshot.getValues(callback).last);
      } else {
        final ref = getDocumentRef(path);
        final snapshots = ref.snapshots();
        yield* snapshots.map((snapshot) => snapshot.getValue(callback));
      }
    } on Exception catch (e) {
      yield null;
    }
  }

  Stream<List<T>> getValuesStream<T>(
      T Function(Map<String, dynamic> map) callback, List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async* {
    try {
      if (path.length.isOdd) {
        final ref = isSubcollection
            ? getGroupCollectionRef(path)
                .getQuery(where, order, start, end, limit)
            : getCollectionRef(path).getQuery(where, order, start, end, limit);

        final snapshots = ref.snapshots();
        yield* snapshots.map((snapshot) => snapshot.getValues(callback));
      } else {
        final ref = getDocumentRef(path);
        final snapshots = ref.snapshots();
        yield* snapshots.map((snapshot) => snapshot.getValue(callback) != null
            ? [snapshot.getValue(callback)!]
            : []);
      }
    } on Exception catch (e) {
      yield [];
    }
  }

  Stream<List<ValueChange<T>>> getValuesChangeStream<T>(
      T Function(Map<String, dynamic> map) callback, List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async* {
    //  List<T> values = [];

    try {
      if (path.length.isOdd) {
        final ref = isSubcollection
            ? getGroupCollectionRef(path)
                .getQuery(where, order, start, end, limit)
            : getCollectionRef(path).getQuery(where, order, start, end, limit);
        final snapshots = ref.snapshots();
        yield* snapshots.map((snapshot) => snapshot.getValuesChange(callback));
      }
    } on FirebaseException catch (e) {
      print("except = $e");
      yield [];
    }
  }

  Future<int> getSnapshotSize(List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async {
    try {
      final ref = isSubcollection
          ? getGroupCollectionRef(path)
              .getQuery(where, order, start, end, limit)
          : getCollectionRef(path);

      final snapshot = await ref.get();
      return snapshot.size;
    } on FirebaseException catch (e) {
      return 0;
    }
  }

  Stream<int> getSnapshotSizeStream(List<String> path,
      {List<dynamic>? where,
      List<dynamic>? order,
      List<dynamic>? start,
      List<dynamic>? end,
      List<dynamic>? limit,
      bool isSubcollection = false}) async* {
    try {
      final ref = isSubcollection
          ? getGroupCollectionRef(path)
              .getQuery(where, order, start, end, limit)
          : getCollectionRef(path).getQuery(where, order, start, end, limit);
      final snapshots = ref.snapshots();
      yield* snapshots.map((snapshot) => snapshot.size);
    } on FirebaseException catch (e) {
      yield 0;
    }
  }

  String getId(List<String> path) {
    try {
      final ref = getCollectionRef(path);
      return ref.doc().id;
    } on FirebaseException catch (e) {
      return "";
    }
  }
}
