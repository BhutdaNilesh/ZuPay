import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zupay/screens/add_movie_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('MovieScreen'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc('movies').snapshots(),
        builder: (BuildContext ctx,AsyncSnapshot snap){
          if(!snap.hasData){
            return CircularProgressIndicator();
          }else {
            try{
              List movies = snap.data['movies'];
              return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (BuildContext ctx, int index){

                    return ListTile(

                      leading: Image(
                        image: NetworkImage(movies[index]['imageUrl']

                        ),
                        height: MediaQuery.of(ctx).size.height*0.08,
                        width: MediaQuery.of(ctx).size.height*0.08,
                      ),
                      title: Text(movies[index]['title']),
                      subtitle: Text(movies[index]['director']),
                      trailing: IconButton(
                        onPressed: ()async{
                          try{
                            dynamic data = await FirebaseFirestore.instance.collection("users").doc("movies").get();
                            List array = data['movies'];
                            array.removeAt(index);
                            print(array);
                            await FirebaseFirestore.instance.collection("users").doc("movies").update(
                                {
                                  'movies': array,
                                }
                            ).then((value) => print("Success"));
                          }catch(e){
                            print('Failure');
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                      horizontalTitleGap: MediaQuery.of(context).size.height*0.05,
                      minVerticalPadding: MediaQuery.of(context).size.height*0.03,
                    );
                  }
              );
            }catch(e){
              return CircularProgressIndicator();
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMovie()));
        },
        child: Icon(Icons.add),

      ),
    );
  }
}
