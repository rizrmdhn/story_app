import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/story_card.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryList extends StatelessWidget {
  final Function onTapped;

  const StoryList({
    Key? key,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) => storyProvider.isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: storyProvider.stories.length,
              itemBuilder: (context, index) {
                final Story story = storyProvider.stories[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: StoryCard(
                    id: story.id,
                    name: story.name,
                    description: story.description,
                    photoUrl: story.photoUrl,
                    createdAt: story.createdAt,
                    lat: story.lat,
                    lon: story.lon,
                    onTapped: () => onTapped(story.id),
                  ),
                );
              },
            ),
    );
  }
}
