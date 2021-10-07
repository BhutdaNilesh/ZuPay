import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';


class Root extends StatefulWidget {
  const Root({ Key? key }) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  final Future<FirebaseApp> _initialization=Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (ctx,snapshot){
          if(snapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                title: Text("ZuPay"),
              ),
              body: Center(
                child: Text(
                    "Oops! Something Went Wrong!\nTry Checking your Connection"
                ),
              ),
            );
          }
          if(snapshot.connectionState==ConnectionState.done){
            return Home();
          }
          return Scaffold(

            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
    );
  }
}