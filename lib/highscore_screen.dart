// the highscore screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighscoresScreen extends StatefulWidget {
  const HighscoresScreen({super.key});

  @override
  State<HighscoresScreen> createState() => _HighscoresScreenState();
}

Widget buildHighScore(BuildContext context,DocumentSnapshot document){

  return ListTile(
    title: Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(document['date'],
        style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.normal),),
        Text(document['score'].toString(),
        style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.normal),),
        ],
      ),
    )
  );
}

class _HighscoresScreenState extends State<HighscoresScreen> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10,30,10,10),
              child: Row(
                
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home,size: 39,),
                  color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Text("High Scores",
                           style: TextStyle(fontWeight: FontWeight.normal,fontSize: 42,color: Colors.white),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Text>[
                    Text("Date",
                    style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.normal),),
                    Text("Score",
                    style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.normal),),
                  ],
                ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('HighScores').snapshots(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData) {
                      return const Center(
                      child: Text("No high score yet..",
                    style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.normal),));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemExtent: 80,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index)=> buildHighScore(context, snapshot.data!.docs[index]),
                    );
                  }
                ),
            ],
          ),
        ),
      );
  }
}