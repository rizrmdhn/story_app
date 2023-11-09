import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/my_app_bar.dart';
import 'package:story_app/components/story_list.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryScreen extends StatelessWidget {
  final Function logoutButtonOnPressed;
  final Function onTapped;
  final Function onAddStoryButtonPressed;

  const StoryScreen({
    Key? key,
    required this.logoutButtonOnPressed,
    required this.onTapped,
    required this.onAddStoryButtonPressed,
  }) : super(key: key);

  static const String routeName = '/story';

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        return Scaffold(
          appBar: MyAppBar(
            title: FlavorConfig.instance.values.titleApp,
            needLogoutButton: true,
            logoutButtonOnPressed: () => logoutButtonOnPressed(),
            needStoryWithLocationButton: true,
            storyWithLocationButtonOnPressed: () {
              storyProvider
                  .setStoryNeedLocation(!storyProvider.isStoryNeedLocation);
            },
            storyWithLocationButtonColor:
                storyProvider.isStoryNeedLocation ? Colors.red : Colors.white,
            storyWithLocationButtonIcon: storyProvider.isStoryNeedLocation
                ? Icons.location_on
                : Icons.location_off,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              onAddStoryButtonPressed();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ), // Icon
          ),
        );
      },
    );
  }
}
