import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Codex',
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
  bool isLogged = false;
  String imageUrl = '';
  String ext = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      var ref = _storage.ref().child('user.avatar${extension(image.path)}');
      ref.putFile(image);
      ext = extension(image.path);
    } else {
      print('No image was selected!');
    }
  }

  Future fetchImage() async {
    var ref = _storage.ref().child('user.avatar${this.ext}');

    if (ref != null) {
      String url = await ref.getDownloadURL();

      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((response) {
      if (response != null) {
        setState(() {
          isLogged = true;
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
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              isLogged && this.imageUrl != ''
                  ? Container(
                      width: 200,
                      height: 200,
                      child: Image.network(
                        this.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : Container(),
              isLogged && this.imageUrl != ''
                  ? SizedBox(
                      height: 30,
                    )
                  : Container(),
              isLogged
                  ? RaisedButton(
                      child: Text('Choose Avatar'),
                      color: Colors.greenAccent,
                      onPressed: uploadImage,
                    )
                  : Container(),
              isLogged
                  ? RaisedButton(
                      child: Text('Show Avatar'),
                      color: Colors.orangeAccent,
                      onPressed: fetchImage,
                    )
                  : Container(),
              isLogged
                  ? Container()
                  : RaisedButton(
                      child: Text(
                        'Login',
                      ),
                      color: Colors.blue[400],
                      onPressed: () async {
                        await _auth.signInWithEmailAndPassword(
                          email: 'user@fakemailaddress.com',
                          password: 'password',
                        );
                        setState(() {
                          isLogged = true;
                        });
                      },
                    ),
              isLogged
                  ? RaisedButton(
                      child: Text(
                        'Logout',
                      ),
                      color: Colors.red[400],
                      onPressed: () {
                        _auth.signOut();
                        setState(() {
                          isLogged = false;
                        });
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
