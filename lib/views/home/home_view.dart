import 'package:chat_app/views/home/home_view_model.dart';
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
  void initState() {
    super.initState();
    ref.read(homeViewModel).getChatsByUser();
    ref.read(homeViewModel).initRealtimeChatsStream();
    ref.read(homeViewModel).autoUpdate();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeViewModel.select((p) => p.chats), (previous, next) {
      ref.read(homeViewModel).initLastMessagesStream();
    });

    return Scaffold(
      appBar: _appBar(),
      drawer: appDrawer(context),
      body: _body(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Chat', style: TextStyle(fontSize: 30)),
      leading: appBarLeading(context),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _searchBar(context),
        const SizedBox(height: 10),
        _chatWidgets(),
      ]
    );
  }

  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: AbsorbPointer(
        child: TextField(
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
        ),
      ),
    );
  }

  Widget _chatWidgets() {
    return Column(
      children: ref.watch(homeViewModel).chats
                .map((chat) => ChatWidget(chat)).toList(),
    );
  }
}