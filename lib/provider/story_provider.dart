import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/localization/main.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/detail_story.dart';
import 'package:story_app/model/story.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  List<Story> _stories = [];
  late DetailStory _detailStory;
  XFile? _image;
  String? _imagePath;
  bool _isFetching = false;

  List<Story> get stories => _stories;
  DetailStory get detailStory => _detailStory;
  XFile? get image => _image;
  String? get imagePath => _imagePath;
  bool get isFetching => _isFetching;

  StoryProvider() {
    initDetailStory();
    getAllStories();
    sortStories();
  }

  void sortStories() {
    _stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  void initDetailStory() {
    _detailStory = DetailStory(
      id: '',
      name: '',
      description: '',
      photoUrl: 'abc',
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void setImage(XFile value) {
    _image = value;
    notifyListeners();
  }

  void setImagePath(String value) {
    _imagePath = value;
    notifyListeners();
  }

  void deleteImage() {
    _image = null;
    _imagePath = null;
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
        AppLocalizations.of(navigatorKey.currentContext!)!.getStoryFailed,
        e.toString(),
      );
      return _stories = [];
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }

  Future<DetailStory> getDetailStories(String id) async {
    try {
      setIsFetching(true);
      final userToken = await _databaseRepository.getUserToken();
      final response = await _apiService.getDetailStory(id, userToken);
      notifyListeners();
      return _detailStory = response.story;
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.getStoryDetailFailed,
        e.toString(),
      );
      return _detailStory;
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }

  Future<void> addNewStory(
    String description,
  ) async {
    try {
      setIsFetching(true);
      final userToken = await _databaseRepository.getUserToken();

      if (_image == null) {
        // throw alert error
        showMyDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.addStoryFailed,
          AppLocalizations.of(navigatorKey.currentContext!)!.imageNotFound,
        );
        return;
      }

      final fileName = _image!.name;
      final bytes = await _image!.readAsBytes();

      final response = await _apiService.addNewStory(
        description,
        bytes,
        fileName,
        userToken,
      );
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.addStorySuccess,
        response.message,
      );
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.addStoryFailed,
        e.toString(),
      );
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }

  void showImage() async {
    return kIsWeb
        ? showMyDialog(
            AppLocalizations.of(navigatorKey.currentContext!)!.error,
            'This feature is not available on $defaultTargetPlatform',
          )
        : await showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                content: Image.file(
                  File(
                    imagePath.toString(),
                  ),
                ),
              );
            },
          );
  }

  void onGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) {
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        'This feature is not available on $defaultTargetPlatform',
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      notifyListeners();

      if (pickedFile != null) {
        setImage(pickedFile);
        setImagePath(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        e.toString(),
      );
    }
  }

  void onCameraView() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) {
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        'This feature is not available on $defaultTargetPlatform',
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
      notifyListeners();

      if (pickedFile != null) {
        setImage(pickedFile);
        setImagePath(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        e.toString(),
      );
    }
  }

  void onCustomCameraView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) {
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        'This feature is not available on $defaultTargetPlatform',
      );
      return;
    }

    // TODO : implement custom camera view and custom view for camera

    try {} catch (e) {}
  }
}
