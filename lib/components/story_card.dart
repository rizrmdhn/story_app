import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // make the card clickable
        onTap: () {},
        child: const Column(
          children: [
            ListTile(
              title: Text('Story data'),
              subtitle: Text('This is a story'),
            ),
          ],
        ),
      ),
    );
  }
}
