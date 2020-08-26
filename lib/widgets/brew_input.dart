import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/brew.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database_service.dart';
import 'package:flutter_firebase/widgets/spinkit.dart';
import 'package:provider/provider.dart';

class BrewInput extends StatefulWidget {
  @override
  _BrewInputState createState() => _BrewInputState();
}

class _BrewInputState extends State<BrewInput> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final List<String> sugars = ['0', '1', '2', '3', '4', '5', '6'];

  Map<String, dynamic> _brewData = {
    'name': null,
    'sugars': null,
    'strength': null,
  };

  Future<void> _updateBrewOfUser(User user, Brew userBrew) async {
    _brewData['name'] ??= userBrew.name;
    _brewData['sugars'] ??= userBrew.sugars;
    _brewData['strength'] ??= userBrew.strength;
    await DatabaseService(uId: user.uId).updateUserData(_brewData);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final user = Provider.of<User>(context);

    return StreamBuilder(
      stream: DatabaseService(uId: user.uId).userBrew,
      builder: (BuildContext context, AsyncSnapshot<Brew> snapshot) {
        if (snapshot.hasData) {
          Brew userBrew = snapshot.data;
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
                    initialValue: _brewData['name'] ?? userBrew.name,
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) {
                      _brewData['name'] = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    value: _brewData['sugars'] ?? userBrew.sugars,
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
                    activeColor: Colors
                        .brown[(_brewData['strength']) ?? userBrew.strength],
                    inactiveColor: Colors
                        .blue[(_brewData['strength']) ?? userBrew.strength],
                    value:
                        (_brewData['strength'] ?? userBrew.strength).toDouble(),
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
                      onPressed: () {
                        _updateBrewOfUser(user, userBrew);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        } else
          return Spinkit();
      },
    );
  }
}
