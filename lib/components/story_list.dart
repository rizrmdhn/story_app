import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/components/custom_loading.dart';
import 'package:story_app/components/story_card.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/map_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'dart:math' as math;

class StoryList extends StatefulWidget {
  final Function onTapped;

  const StoryList({
    Key? key,
    required this.onTapped,
  }) : super(key: key);

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController loaderController;
  late Animation<double> loaderAnimation;

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

    loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    loaderAnimation = Tween(begin: 1.0, end: 1.4).animate(CurvedAnimation(
      parent: loaderController,
      curve: Curves.easeIn,
    ));
    loaderController.repeat(reverse: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    loaderController.dispose();
    loaderAnimation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoryProvider, MapProvider>(
      builder: (context, storyProvider, mapProvider, child) {
        if (storyProvider.isFetching == true && storyProvider.pageItems == 1) {
          return Center(
            child: AnimatedBuilder(
              animation: loaderController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: loaderController.status == AnimationStatus.forward
                      ? (math.pi * 2) * loaderController.value
                      : -(math.pi * 2) * loaderController.value,
                  child: CustomPaint(
                    foregroundPainter: LoaderAnimation(
                      radiusRatio: loaderAnimation.value,
                    ),
                    size: const Size(300, 300),
                  ),
                );
              },
            ),
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
                  lat: story.lat,
                  lon: story.lon,
                  onTapped: () async {
                    context.read<StoryProvider>().setIsFetching(true);
                    context.read<MapProvider>().clearMarkerAndPlacemark();
                    var userLatLng = LatLng(
                      story.lat,
                      story.lon,
                    );
                    context.read<StoryProvider>().getDetailStories(story.id);
                    var response = await context
                        .read<MapProvider>()
                        .setUserLatLng(userLatLng);

                    if (response.error == true) {
                      widget.onTapped(story.id, response);
                    } else {
                      widget.onTapped(story.id, response);
                    }
                  },
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
