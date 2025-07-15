import 'dart:convert';

import 'package:flutter_turtrial/app_state.dart';
import 'package:flutter_turtrial/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'app_notifire_provider.g.dart';

@riverpod
class AppNotifier extends _$AppNotifier {
  @override
  AppState build() {
    return const Input();
  }

  void reset() {
    state = const Input();
  }

  Future<void> convert(String sentence) async {
    state = const Loading();

    final url = Uri.parse('http://localhost:3000/test');
    final headers = {'Content-Type': 'application/json'};
    final request = Request(appId: 'testId', sentence: sentence);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(request.toJson())
    );
    final result = Response.fromJson(
      jsonDecode(response.body) as Map<String, Object?>,
    );

    state = Data(result.converted);
  }
}