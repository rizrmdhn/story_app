import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/detail_story.dart';
import 'package:story_app/model/story.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  List<Story> _stories = [];
  bool _isFetching = false;
  DetailStory? _detailStory;

  List<Story> get stories => _stories;
  bool get isFetching => _isFetching;
  DetailStory? get detailStory => _detailStory;

  StoryProvider() {
    getAllStories();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  Future<List<Story>> getAllStories() async {
    try {
      setIsFetching(true);
      final userToken = await _databaseRepository.getUserToken();
      final response = await _apiService.getAllStories(userToken);
      notifyListeners();
      return _stories = response.listStory;
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        'Error',
        e.toString(),
      );
      return _stories = [];
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }
}
