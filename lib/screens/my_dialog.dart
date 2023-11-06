import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';

class MyDialog extends Page {
  final String title;
  final String message;

  MyDialog({
    required this.title,
    required this.message,
  }) : super(key: ValueKey(title));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      // background transparent
      opaque: false,
      settings: this,
      barrierDismissible: true,
      pageBuilder: (context, animation, animation2) {
        return Center(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().setIsFetching(false);
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
