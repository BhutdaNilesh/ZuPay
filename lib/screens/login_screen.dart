import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zupay/screens/movie_screen.dart';
import 'google_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              SizedBox(height: height*0.2,),
              Center(
                child: Image(
                  image: AssetImage("images/logo.png"),
                  height: height*0.3,
                  width: width*0.3,
                ),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: ()async{
                  // await signInWithGoogle().then((result){
                  //   print('outside');
                  //   if(result!=null){
                  //     print('Google Sign in');
                  //     FirebaseFirestore.instance.collection("users").doc(result.user!.uid).set({}).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieScreen())));
                  //   }else{
                  //     print('failure');
                  //   }
                  // },
                  try {
                    await _googleSignIn.signIn();
                  } catch (error) {
                    print(error);
                  };

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


