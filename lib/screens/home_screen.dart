import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/brew.dart';
import 'package:flutter_firebase/services/auth_service.dart';
import 'package:flutter_firebase/services/database_service.dart';
import 'package:flutter_firebase/widgets/brew_input.dart';
import 'package:flutter_firebase/widgets/brewlist.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authService = AuthService();

    void _addNewBrew(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builderContext) {
          return BrewInput();
        },
      );
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addNewBrew(context),
              ),
              FlatButton.icon(
                onPressed: () {
                  _authService.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Log out'),
              )
            ],
          ),
          body: BrewList(),
        ),
      ),
    );
  }
}
