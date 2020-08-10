import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/authenticate_screen.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<User>(
          builder: (context, user, child) {
            return user != null ? HomeScreen() : AuthenticateScreen();
          },
        ),
      ),
    );
  }
}
