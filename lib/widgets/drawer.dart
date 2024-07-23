import 'package:flutter/material.dart';

Widget appBarLeading(BuildContext context) {
  return Builder(
    builder: (context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    },
  );
}

Widget appDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: const Text('Chats'),
          onTap: () {
            if (ModalRoute.of(context)!.settings.name == '/home') {
              return;
            }
            Navigator.pushReplacementNamed(context, '/home');
          },
          style: ListTileStyle.drawer,
        ),
        ListTile(
          title: const Text('Account'),
          onTap: () {
            if (ModalRoute.of(context)!.settings.name == '/account') {
              return;
            }
            Navigator.pushReplacementNamed(context, '/account');
          },
          style: ListTileStyle.drawer,
        ),
      ],
    )
  );
}