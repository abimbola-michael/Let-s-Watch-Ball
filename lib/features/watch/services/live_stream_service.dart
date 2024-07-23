import 'package:dio/dio.dart';
import 'package:watchball/features/watch/models/stream_info.dart';

import '../../match/models/live_match.dart';

Future<List<LiveMatch>> getMatches() async {
  final dio = Dio();

  final options = Options(
    //method: 'GET',
    headers: {
      'x-rapidapi-key': 'ddd5e8a399mshe43fb9e23b2e887p1f95aejsn2d5531f5c59a',
      'x-rapidapi-host': 'football-live-stream-api.p.rapidapi.com',
    },
    // headers: {
    //   'X-RapidAPI-Key': 'ddd5e8a399mshe43fb9e23b2e887p1f95aejsn2d5531f5c59a',
    //   'X-RapidAPI-Host': 'football-live-stream-api.p.rapidapi.com'
    // },
  );

  try {
    final response = await dio.get(
      'https://football-live-stream-api.p.rapidapi.com/index.php',
      options: options,
    );
    final result = response.data;
    print("result:$result");

    final output = (result as List<dynamic>)
        .map((value) => LiveMatch.fromMap(value))
        .toList();
    print(output);
    //getLiveStream("wellington-phoenix-vs-melbourne-victory-18-05-2024");

    return output;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

Future<List<StreamInfo>> getLiveStream(String id) async {
  final dio = Dio();

  final options = Options(
    // method: 'GET',
    headers: {
      'x-rapidapi-key': 'ddd5e8a399mshe43fb9e23b2e887p1f95aejsn2d5531f5c59a',
      'x-rapidapi-host': 'football-live-stream-api.p.rapidapi.com',
    },
    // headers: {
    //   'X-RapidAPI-Key': 'ddd5e8a399mshe43fb9e23b2e887p1f95aejsn2d5531f5c59a',
    //   'X-RapidAPI-Host': 'football-live-stream-api.p.rapidapi.com',
    // },
  );

  try {
    final response = await dio.get(
      'https://football-live-stream-api.p.rapidapi.com/stream.php',
      options: options,
      queryParameters: {
        'id': id,
      },
    );
    final result = response.data;
    print("result:$result");

    final output = (result as List<dynamic>)
        .map((value) => StreamInfo.fromMap(value))
        .toList();
    print(output);
    return output;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}
