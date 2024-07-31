import 'package:chat_app/views/search/search_view_model.dart';
import 'package:chat_app/views/search/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {

  @override
  void initState() {
    super.initState();
    ref.read(searchViewModel).filterChatsByName('');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: _searchBar()
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _userResult(),
        ],
      )
    );
  }

  Widget _searchBar() {
    return TextField(
      autofocus: true,
      style: const TextStyle(
        fontSize: 20,
      ),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Search...",
        border: InputBorder.none
      ),
      onChanged: (value) {
        ref.read(searchViewModel).filterChatsByName(value);
      },
    );
  }

  Widget _userResult() {
    return Expanded(
      child: ListView(
        children: ref.watch(searchViewModel).result
          .map((chat) => SearchResultWidget(chat)).toList(),
      ),
    );
  }
}