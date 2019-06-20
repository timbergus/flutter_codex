import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password;
  bool loginError = false;

  final _loginFormKey = GlobalKey<FormState>();

  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((response) {
      if (response.uid != null) {
        setState(() {
          Navigator.pushReplacementNamed(context, '/profile');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _loginFormKey,
          child: Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: 'user@fakemailaddress.com',
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'You must enter a valid email!';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: 'password',
                    obscureText: true,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'You must enter a valid password!';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    color: Colors.blue[300],
                    onPressed: () async {
                      print(_password);
                      try {
                        if (_loginFormKey.currentState.validate()) {
                          _loginFormKey.currentState.save();
                        }

                        _user = await _auth.signInWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        );

                        if (_user.uid != null) {
                          setState(() {
                            Navigator.pushReplacementNamed(context, '/profile');
                          });
                        } else {
                          setState(() {
                            loginError = true;
                          });
                        }
                      } catch (e) {
                        setState(() {
                          loginError = true;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  loginError
                      ? Text(
                          'Please, check your credentials and try again',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
