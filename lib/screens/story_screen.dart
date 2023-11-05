import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/my_app_bar.dart';
import 'package:story_app/components/story_list.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryScreen extends StatelessWidget {
  final Function logoutButtonOnPressed;
  final Function onTapped;

  const StoryScreen({
    Key? key,
    required this.logoutButtonOnPressed,
    required this.onTapped,
  }) : super(key: key);

  static const String routeName = '/story';

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        return Scaffold(
          appBar: MyAppBar(
            title: 'Story',
            needLogoutButton: true,
            logoutButtonOnPressed: () => logoutButtonOnPressed(),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.015,
                    left: MediaQuery.of(context).size.width * 0.10,
                    right: MediaQuery.of(context).size.width * 0.10,
                    bottom: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: StoryList(
                    onTapped: onTapped,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
