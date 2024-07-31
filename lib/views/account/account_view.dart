import 'package:chat_app/views/account/account_view_model.dart';
import 'package:chat_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {

  @override
  void initState() {
    super.initState();
    ref.read(accountViewModel).checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: appDrawer(context),
      // body: _body(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Account'),
      leading: appBarLeading(context),
      actions: [
        _signOutBtn(context),
      ],
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Center(child: Text(ref.watch(accountViewModel).currentUser!.name))
    );
  }

  Widget _signOutBtn(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await ref.read(accountViewModel).signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
      },
      icon: const Icon(Icons.logout),
    );
  }
}