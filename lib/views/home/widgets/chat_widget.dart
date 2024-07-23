import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatWidget extends ConsumerWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {},
      leading: FlutterLogo(size: 30),
      title: Text('User name'),
      subtitle: Row(
        children: [
          Flexible(
            child: Text(
              'Message may be so longggggggggggg',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(' · '),
          Text('5m ago',
          ),
        ],
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}