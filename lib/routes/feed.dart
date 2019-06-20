import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
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
          stream: Firestore.instance
              .collection('feed')
              .where('email', isEqualTo: 'user@fakemailaddress.com')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  alignment: Alignment.centerLeft,
                  color: index % 2 == 0 ? Colors.yellow[100] : Colors.white,
                  child: Text(
                    '${snapshot.data.documents[index]['message']}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
