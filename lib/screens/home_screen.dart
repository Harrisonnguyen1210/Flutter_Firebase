import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authService = AuthService();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: FlatButton(
            child: Text('Log out'),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ),
      ),
    );
  }
}
