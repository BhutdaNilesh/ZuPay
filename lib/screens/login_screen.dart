// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:zupay/screens/movie_screen.dart';
// import 'google_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var height=MediaQuery.of(context).size.height;
//     var width=MediaQuery.of(context).size.width;
//
//     GoogleSignIn _googleSignIn = GoogleSignIn(
//       scopes: [
//         'email',
//         'https://www.googleapis.com/auth/contacts.readonly',
//       ],
//     );
//
//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//
//               SizedBox(height: height*0.2,),
//               Center(
//                 child: Image(
//                   image: AssetImage("images/logo.png"),
//                   height: height*0.3,
//                   width: width*0.3,
//                 ),
//               ),
//               SignInButton(
//                 Buttons.Google,
//                 onPressed: (){
//
//
//
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zupay/screens/movie_screen.dart';

import 'google_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading ?Center(child: CircularProgressIndicator(),) : Center(
        child: Column(
          children: [
            SizedBox(height: height*0.2,),
              Center(
                child: Image(
                  image: AssetImage("images/logo.png"),
                  height: height*0.3,
                  width: width*0.3,
                ),),
            ElevatedButton(
              child: Text("SignIn with google"),
              onPressed: ()async{
                setState(() {
                  isLoading=true;
                });
                Authentication _authentication=Authentication();
                try{
                  await _authentication.signInwithGoogle().whenComplete((){
                    Fluttertoast.showToast(msg: "Signed In!");

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MovieScreen()));
                  });
                }
                catch(e){
                  if(e is FirebaseAuthException){
                    Fluttertoast.showToast(msg: "Error occurred while signing in...!");
                  }
                }
                setState(() {
                  isLoading=false;
                });
              },
            ),
          ],
        )
      ),
    );
  }
}