import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_turtrial/model/post.dart';

part 'post_list_provider.g.dart';

@riverpod
class PostList extends _$PostList {

  @override
  Future<List<Post>> build() async {
    final response = await http.get(Uri.parse('http://localhost:3000/posts'));

    // print('Response status: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Failed to load posts');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();

  }
}