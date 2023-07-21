// this the screen that has 2 choicesand lead to 2 screens:
// 1- the Hangman game
// 2- the highscores screen that shows the high score and the date u got the highscore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangman/hangman.dart';
import 'package:hangman/highscore_screen.dart';
class LandingScreen extends StatelessWidget {
   
  //  i made this var a static so i can use it in the game screen...
   static int highScore = 0;
  //  this will return a future value to return an int value i need to use async and await so that i used it in the button pressed function
  // this function gets the latest high score
   getHighScore() async{
    var collection = FirebaseFirestore.instance.collection('HighScores');
    var allDocs = await collection.get();
    var docId = allDocs.docs.first.data();
    return docId['score'];
  }
  // ignore: prefer_const_constructors_in_immutables
  LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("HANGMAN",
            style: TextStyle(fontSize: 58,fontWeight: FontWeight.w300,fontFamily: 'PatrickHand',letterSpacing: 3.0,color: Colors.white),),
            Image(
              image: const AssetImage("images/gallow.png"),
              height: MediaQuery.of(context).size.height*0.49,
            ),

            Column(
              children: <Container>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: MaterialButton(
                    height: 70,
                    minWidth: 155,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: const Color(0xFF1089ff),
                    highlightColor: const Color(0xFF1089ff),
                    elevation: 3,
                    child: const Text("Start",
                    style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w300,letterSpacing: 0.5)),
                    onPressed: () async{
                      highScore = await getHighScore();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> const HangmanScreen()));
                        },
                      ),
                    ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: MaterialButton(
                  height: 70,
                  minWidth: 155,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: const Color(0xFF1089ff),
                  highlightColor: const Color(0xFF1089ff),
                  elevation: 3,
                  child: const Text("High Scores",
                  style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w300,letterSpacing: 0.5),),
                  onPressed: () async{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const HighscoresScreen()));
                  },
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}