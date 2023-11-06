import 'dart:convert';
import 'dart:typed_data';
import 'package:story_app/model/response/add_new_story_guest_response.dart';
import 'package:story_app/model/response/add_new_story_response.dart';
import 'package:story_app/model/response/get_all_stories_response.dart';
import 'package:story_app/model/response/get_detail_story_response.dart';
import 'package:story_app/model/response/login_response.dart';
import 'package:story_app/model/response/register_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    var url = '$baseUrl/register';

    var body = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );

      return RegisterResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginRepsonse> login(String email, String password) async {
    var url = '$baseUrl/login';

    var body = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );

      return LoginRepsonse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AddNewStoryRepsonse> addNewStory(
    String description,
    List<int> bytes,
    String fileName,
    LoginResult userToken,
  ) async {
    var url = '$baseUrl/stories';
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${userToken.token}'
    };

    Map<String, String> body = {
      'description': description,
    };

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );

    try {
      request.headers.addAll(headers);
      request.fields.addAll(body);
      request.files.add(multiPartFile);

      final http.StreamedResponse streamedResponse = await request.send();
      final Uint8List responseList = await streamedResponse.stream.toBytes();
      final String responseData = String.fromCharCodes(responseList);

      return AddNewStoryRepsonse.fromJson(jsonDecode(responseData));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AddNewStoryRepsonseGuest> addNewStoryGuest(String name,
      String description, String photoUrl, double lat, double lon) async {
    var url = '$baseUrl/stories/guest';

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
        body: body,
      );

      return AddNewStoryRepsonseGuest.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GetAllStoriesResponse> getAllStories(LoginResult userToken) async {
    var url = '$baseUrl/stories';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userToken.token}'
    };

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

  Future<GetDetailStoryRepsonse> getDetailStory(
    String id,
    LoginResult userToken,
  ) async {
    var url = '$baseUrl/stories/$id';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userToken.token}'
    };

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
