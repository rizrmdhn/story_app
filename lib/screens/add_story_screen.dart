import 'package:flutter/material.dart';

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
                ),
                child: Column(
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
  }
}
