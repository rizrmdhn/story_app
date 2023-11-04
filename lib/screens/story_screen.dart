import 'package:flutter/material.dart';
import 'package:story_app/components/story_card.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  static const String routeName = '/story';

  @override
  Widget build(BuildContext context) {
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
  }
}
