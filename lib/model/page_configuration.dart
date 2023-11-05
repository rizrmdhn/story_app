class PageConfiguration {
  final bool unknown;
  final bool? loggedIn;
  final bool isRegister;
  final bool addStory;

  PageConfiguration.splash()
      : unknown = false,
        loggedIn = null,
        isRegister = false,
        addStory = false;

  PageConfiguration.login()
      : unknown = false,
        loggedIn = false,
        isRegister = false,
        addStory = false;

  PageConfiguration.register()
      : unknown = false,
        loggedIn = false,
        isRegister = true,
        addStory = false;

  PageConfiguration.story()
      : unknown = false,
        loggedIn = true,
        isRegister = false,
        addStory = false;

  PageConfiguration.addStory()
      : unknown = false,
        loggedIn = true,
        isRegister = false,
        addStory = true;

  PageConfiguration.unknown()
      : unknown = true,
        loggedIn = null,
        isRegister = false,
        addStory = false;

  bool get isSplashPage => unknown == false && loggedIn == null;
  bool get isLoginPage => unknown == false && loggedIn == false;
  bool get isRegisterPage => isRegister == true;
  bool get isStoryPage =>
      unknown == false && loggedIn == true && addStory == false;
  bool get isAddStoryPage =>
      unknown == false && loggedIn == true && addStory == true;

  bool get isUnknownPage => unknown == true;
}
