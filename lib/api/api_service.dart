import 'dart:convert';

import 'package:story_app/model/response/add_new_story_guest_response.dart';
import 'package:story_app/model/response/add_new_story_response.dart';
import 'package:story_app/model/response/get_all_stories_response.dart';
import 'package:story_app/model/response/get_detail_story_response.dart';
import 'package:story_app/model/response/login_response.dart';
import 'package:story_app/model/response/register_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterRepsonse> register(
      String name, String email, String password) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'name': name,
      'email': email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      return RegisterRepsonse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<LoginRepsonse> login(String email, String password) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'email': email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      return LoginRepsonse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<AddNewStoryRepsonse> addNewStory(String name, String description,
      String photoUrl, DateTime createdAt, double lat, double lon) async {
    var url = '$baseUrl/story';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lat': lat,
      'lon': lon,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      return AddNewStoryRepsonse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add new story');
    }
  }

  Future<AddNewStoryRepsonseGuest> addNewStoryGuest(String name,
      String description, String photoUrl, double lat, double lon) async {
    var url = '$baseUrl/story/guest';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'lat': lat,
      'lon': lon,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      return AddNewStoryRepsonseGuest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add new story');
    }
  }

  Future<GetAllStoriesRepsonse> getAllStories() async {
    var url = '$baseUrl/story';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return GetAllStoriesRepsonse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get all stories');
    }
  }

  Future<GetDetailStoryRepsonse> getDetailStory(String id) async {
    var url = '$baseUrl/story/$id';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return GetDetailStoryRepsonse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get detail story');
    }
  }
}
