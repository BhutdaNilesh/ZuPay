

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zupay/screens/movie_screen.dart';


class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final _formKey = GlobalKey<FormState>();
  final _auth=FirebaseAuth.instance;

  late String movieTitle;
  late String movieDirector;
  bool isLoading=false;

  late File _imageFile;
  final picker = ImagePicker();
  late String imageUrl;

  // FirebaseStorage storage = FirebaseStorage.instance;
  // Future pickImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _imageFile = File(pickedFile!.path);
  //   });
  // }
  //
  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = basename(_imageFile.path);
  //   Reference firebaseStorageRef =
  //   FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
  //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  //   taskSnapshot.ref.getDownloadURL().then(
  //         (value) => print("Done: $value"),
  //   );
  // }

  CollectionReference movies = FirebaseFirestore.instance.collection('movies');




  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.06,vertical: height*0.06),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.title),
                      labelText: "Title",
                       hintText: "Enter the movie title"
                    ),
                    validator: (val){
                      if(val!.isEmpty){
                        return "Enter the Director name";
                      }else{
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        movieTitle=val;
                      });
                    },
                  ),
                  SizedBox(height: height*0.04,),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Director",
                        hintText: "Name of Director"
                    ),
                    validator: (val){
                      if(val!.isEmpty){
                        return "Enter the Director name";
                      }else{
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        movieDirector=val;
                      });
                    },
                  ),
                  SizedBox(height: height*0.04,),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: ()async{
                            var image = await picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                _imageFile = File(image.path);
                              });
                            }

                          },
                          child: Text('Add Movie Poster')
                      ),
                      SizedBox(width: width*0.03,),
                      ElevatedButton(
                          onPressed: ()async{
                            String fileName = basename(_imageFile.path);
                            Reference reference = FirebaseStorage.instance
                                .ref()
                                .child('posterImage/$fileName');
                            UploadTask uploadTask = reference.putFile(_imageFile);
                            TaskSnapshot snapshot = await uploadTask;
                            imageUrl = await snapshot.ref.getDownloadURL();
                            print(imageUrl);
                          },
                          child: Text('Upload Movie Poster')
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.04,),
                  ElevatedButton(
                      onPressed: ()async{
                        try{
                          dynamic data = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                          List array = data['movies'];
                          array.add({
                            "title": movieTitle,
                            "director": movieDirector,
                            "imageUrl": imageUrl,
                          });
                          print(array);
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                            {
                              'movies': array,
                            }
                          ).then((value) {
                            print("Success");
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (conext)=>MovieScreen()));
                          });

                        }catch(e){
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                              {
                                'movies': {
                                  "title": movieTitle,
                                  "director": movieDirector,
                                  "imageUrl": imageUrl,
                                },
                              }
                          ).then((value) => print("Success"));
                          print('Failure');
                        }
                      },
                      child: Text('Submit')
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
