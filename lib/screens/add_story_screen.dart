import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_provider.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({Key? key}) : super(key: key);

  static const String routeName = '/add_story';

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: const Text(
                    'Add Story',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Column(
                          // the children should be aligned to the center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            // the form
                            Form(
                              child: Column(
                                children: [
                                  const SizedBox(height: 20.0),
                                  // the content field
                                  TextFormField(
                                    controller: _contentController,
                                    decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      labelText: 'Content',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 10,
                                  ),
                                  const SizedBox(height: 20.0),
                                  // the submit button
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Upload'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: const Text(
                    'Add Story',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Column(
                      children: [
                        // image placeholder preview
                        SizedBox(
                          width: 350,
                          height: 250,
                          child: Center(
                            child: storyProvider.imagePath == null
                                ? const Icon(Icons.image, size: 100.0)
                                : Image.file(
                                    File(
                                      context
                                          .read<StoryProvider>()
                                          .imagePath!
                                          .toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // row for gallery and camera
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // gallery button
                            ElevatedButton(
                              onPressed: () {
                                context.read<StoryProvider>().onGalleryView();
                              },
                              child: const Text('Gallery'),
                            ),
                            // camera button
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Camera'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        // the form
                        Form(
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
                              // the content field
                              TextFormField(
                                controller: _contentController,
                                decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  labelText: 'Content',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 10,
                              ),
                              const SizedBox(height: 20.0),
                              // the submit button
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Upload'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
