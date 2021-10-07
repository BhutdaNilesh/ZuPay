import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'google_auth.dart';
import 'home.dart';
import 'login_screen.dart';
import 'movie_screen.dart';




class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Authentication _authentication = Authentication();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rogers"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_auth.currentUser!.photoURL!),
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: Text("Are you sure you want to Logout?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                }, child: Text("NO")),
                            ElevatedButton(
                                onPressed: () async {
                                  await _authentication
                                      .signOutFromGoogle()
                                      .then((value) {
                                    Fluttertoast.showToast(msg: "Signing out...");
                                    Navigator.pop(ctx);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>Home()));
                                  });
                                },
                                child: Text("YES")),
                          ],
                        );
                      });
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_auth.currentUser!.displayName!),
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MovieScreen()));
            },
                child: Text("Go to Movies List"))
          ],
        ),
      ),
    );
  }
}