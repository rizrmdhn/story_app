import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/story_card.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryList extends StatefulWidget {
  final Function onTapped;

  const StoryList({
    Key? key,
    required this.onTapped,
  }) : super(key: key);

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final StoryProvider storyProvider = context.read<StoryProvider>();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (storyProvider.pageItems != null) {
            storyProvider.getAllStories();
          }
        }
      },
    );

    Future.microtask(() => storyProvider.getAllStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        if (storyProvider.isFetching == true && storyProvider.pageItems == 1) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (storyProvider.stories.isNotEmpty) {
          return ListView.builder(
            controller: scrollController,
            itemCount: storyProvider.stories.length +
                (storyProvider.pageItems != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == storyProvider.stories.length &&
                  storyProvider.pageItems != null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

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
                  onTapped: () => widget.onTapped(story.id),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text('No Story'),
          );
        }
      },
    );
  }
}
