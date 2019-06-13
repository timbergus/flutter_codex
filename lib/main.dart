import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool logged = false;

  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((response) {
      print(response.uid);
      if (response.uid != null) {
        setState(() {
          logged = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Codex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logged ? Container() : RaisedButton(
              child: Text('Login'),
              color: Colors.blue[300],
              onPressed: () async {
                try {
                  _user = await _auth.signInWithEmailAndPassword(
                    email: 'user@fakemailaddress.com',
                    password: 'password',
                  );
                  print(_user);
                  setState(() {
                    logged = true;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
            logged ? RaisedButton(
              child: Text('Logout'),
              color: Colors.red[300],
              onPressed: () async {
                try {
                  await _auth.signOut();
                  setState(() {
                    logged = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ) : Container(),
            SizedBox(
              height: 20,
            ),
            logged
                ? Text(
                    'The user is logged!',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                : Text(
                    'The user is not logged!',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
