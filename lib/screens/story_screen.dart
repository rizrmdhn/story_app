import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/story_card.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  static const String routeName = '/story';

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        print(storyProvider.stories.length);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              'Story',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: const Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: StoryCard(),
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
