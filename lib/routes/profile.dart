import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            DocumentSnapshot _user = snapshot.data.documents[0];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${_user['name']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${_user['surname']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${_user['address']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${_user['birthday']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${_user['company']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text('Feed'),
                    color: Colors.blue[300],
                    onPressed: () {
                      Navigator.pushNamed(context, '/feed');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
