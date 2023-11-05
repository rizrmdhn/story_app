import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class DetailStoryScreen extends StatelessWidget {
  final String storyId;

  const DetailStoryScreen({
    Key? key,
    required this.storyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, value, child) => value.isFetching
          ? const Center(child: CircularProgressIndicator())
          : Material(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        // add favorite button in image background
                        background: Stack(
                          children: [
                            Image.network(
                              value.detailStory.photoUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          value.detailStory.lat.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                // scroll view
                body: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              value.detailStory.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // created at
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            // convert to local timezone (Asia/Jakarta) to readable date
                            child: Text(
                              '${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).day.toString()} / ${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).month.toString()} / ${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).year.toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          // description
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              value.detailStory.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
