import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database_service.dart';
import 'package:provider/provider.dart';

class BrewInput extends StatefulWidget {
  @override
  _BrewInputState createState() => _BrewInputState();
}

class _BrewInputState extends State<BrewInput> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final List<String> sugars = ['0', '1', '2', '3', '4', '5', '6'];

  Map<String, dynamic> _brewData = {
    'name': '',
    'sugars': '0',
    'strength': 100,
  };

  Future<void> _updateBrewOfUser(User user) async {
    await DatabaseService(uId: user.uId).updateUserData(_brewData);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final user = Provider.of<User>(context);

    return Padding(
      padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0,
          bottom: mediaQuery.viewInsets.bottom + 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update your brew settings.'),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) =>
                  value.isEmpty ? 'Please enter a name' : null,
              onChanged: (value) {
                _brewData['name'] = value;
              },
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField(
              value: _brewData['sugars'] ?? '0',
              items: sugars
                  .map((sugar) => DropdownMenuItem(
                      child: Text('$sugar sugars'), value: sugar))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _brewData['sugars'] = val;
                });
              },
            ),
            SizedBox(height: 20.0),
            Slider(
              activeColor:
                  Colors.brown[(_brewData['strength'])],
              inactiveColor:
                  Colors.blue[(_brewData['strength'])],
              value: _brewData['strength'].toDouble(),
              min: 100,
              max: 900,
              divisions: 8,
              onChanged: (value) {
                setState(() {
                  _brewData['strength'] = value.round();
                });
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.pink[400],
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _updateBrewOfUser(user),
            ),
          ],
        ),
      ),
    );
  }
}