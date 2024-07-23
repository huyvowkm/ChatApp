import 'package:chat_app/views/home/widgets/chat_widget.dart';
import 'package:chat_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: appDrawer(context),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Chat', style: TextStyle(fontSize: 30)),
      leading: appBarLeading(context),
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _searchBar(),
        const SizedBox(height: 10),
        _chatWidgets(),
      ]
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: const Icon(Icons.search),
        hintText: "Search user or group chat...",
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.white
          )
        )
      ),
    );
  }

  Widget _chatWidgets() {
    return Column(
      children: [
        ChatWidget(),
        ChatWidget(),

      ],
    );
  }

   

}