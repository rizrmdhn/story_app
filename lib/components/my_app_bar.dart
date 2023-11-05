import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? needLogoutButton;
  final Function? logoutButtonOnPressed;

  const MyAppBar({
    Key? key,
    required this.title,
    this.needLogoutButton,
    this.logoutButtonOnPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        if (needLogoutButton == true)
          IconButton(
            onPressed: () => logoutButtonOnPressed!(),
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
