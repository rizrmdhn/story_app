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

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName('utf-8'),
      );

      return RegisterRepsonse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginRepsonse> login(String email, String password) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName('utf-8'),
      );

      return LoginRepsonse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AddNewStoryRepsonse> addNewStory(String name, String description,
      String photoUrl, DateTime createdAt, double lat, double lon) async {
    var url = '$baseUrl/stories';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lat': lat,
      'lon': lon,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName('utf-8'),
      );

      return AddNewStoryRepsonse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AddNewStoryRepsonseGuest> addNewStoryGuest(String name,
      String description, String photoUrl, double lat, double lon) async {
    var url = '$baseUrl/stories/guest';
    var headers = {'Content-Type': 'application/json'};

    var body = {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'lat': lat,
      'lon': lon,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName('utf-8'),
      );

      return AddNewStoryRepsonseGuest.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GetAllStoriesResponse> getAllStories() async {
    var url = '$baseUrl/stories?location=1';
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      return GetAllStoriesResponse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GetDetailStoryRepsonse> getDetailStory(String id) async {
    var url = '$baseUrl/stories/$id';
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      return GetDetailStoryRepsonse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
