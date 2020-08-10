import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth_service.dart';

enum AuthMode { Signup, Login }

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An error occurred'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    try {
      if (_authMode == AuthMode.Signup) {
        await _authService.register(_authData);
      } else {
        await _authService.signInWithEmailAndPassword(_authData);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              onSaved: (email) {
                _authData['email'] = email.trim();
              },
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              onSaved: (password) {
                _authData['password'] = password;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
                return null;
              },
            ),
            _authMode == AuthMode.Login
                ? SizedBox()
                : TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.pink[400],
              child: Text(_authMode == AuthMode.Login ? 'Sign in' : 'Register'),
              onPressed: _submit,
            ),
            FlatButton(
              child: Text(
                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
              onPressed: _switchAuthMode,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
