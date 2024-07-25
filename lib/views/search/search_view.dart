import 'package:chat_app/views/search/search_view_model.dart';
import 'package:chat_app/views/search/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _searchBar(),
          _userResult(),
        ],
      )
    );
  }

  Widget _searchBar() {
    return TextField(
      autofocus: true,
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
      onChanged: (value) {
        ref.read(searchViewModel).filterUsersByName(value);
      },
    );
  }

  Widget _userResult() {
    return Expanded(
      child: ListView(
        children: ref.watch(searchViewModel).users
          .map((user) => UserWidget(user)).toList(),
      ),
    );
  }
}