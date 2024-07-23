import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/utils/utils.dart';

import '../../../firebase/firestore_methods.dart';

final FirestoreMethods firestoreMethods = FirestoreMethods();
Stream<List<ValueChange<LiveMatch>>> streamChangeUpdates(
    String? lastTime) async* {
  final now = DateTime.now();
  final date = getFullDate(now);
  final time = getFullTime(now);

  yield* firestoreMethods.getValuesChangeStream(
    (map) => LiveMatch.fromMap(map),
    ["matches"],
    order: ["createdAt"],
    where: [
      "date",
      "<=",
      date,
      "time",
      "<=",
      time,
      if (lastTime != null) ...["modifiedAt", ">", lastTime]
    ],
    isSubcollection: true,
  );
}
