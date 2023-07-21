// the hangman game screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangman/hangman_words.dart';
import 'package:hangman/landing_screen.dart';
import 'package:intl/intl.dart';



class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}


class _HangmanScreenState extends State<HangmanScreen> {

  // a var that gets the score
  int score = 0;
  
  // var that indicate the lives
  int life = 5;

  // var that indicate the tries 
  int tries = 5;

  // bool var to decide if u lose or win and change the coor of the dialog alert
  bool win = false;

  // here to let the hint only clickable once
  bool isHintClickable = true;

  // getting the first word...
  HangmanWords words = HangmanWords();
  late String word = words.getWord();
  late String wordHidden = words.getHiddenWord(word.length);


  // alphabets string so i can use the GridViewbuilder
  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  // generating a list of true values for every button to indicate wether they are clickable or not by changing the value to false
  List <bool>isButtonClickable = List.generate(26, (index) {
      return true;
    });


  // this the function to make the button clickable once for multiple buttons at different clicks 
  // to make it easier to debug and easy to use in the onpressed function later in the GridView.Builder

  void whenButtonPressed(int index){
    if(isButtonClickable[index]){
      if(!word.contains(alphabet[index].toLowerCase())){
        setState(() {
          if(tries<=0){
            tries = -1;
            if(life<=0){
              win = false;
              winOrLoseDialog();
              }
            else{
              life--;
              win = false;
              winOrLoseDialog();
              // then gets a new word...
              }
            }
          else{
            tries--;
            }
          });
        }
      else{
        for (int i = 0; i<word.length;i++){
         if(word[i] == alphabet[index].toLowerCase()){
            setState(() {
              wordHidden = wordHidden.substring(0,i) + alphabet[index] + wordHidden.substring(i+1,wordHidden.length);
              if(wordHidden.toLowerCase() == word){
                win = true;
                winOrLoseDialog();
                }
              });
            }
          }
        }
      setState(() {
        isButtonClickable[index] = false;
        });
    }
  }
  
  // this is the dialog that pop after the tries ends or the word is guessed
Future winOrLoseDialog()=> showDialog(
  
  // using it so u cant go back to the dialog again bby clicking the back button in the phone
  useRootNavigator: false,
  
  // thia property it doent make it possible to go back to what happens before the dialog pops up
  barrierDismissible: false,
  barrierColor: Colors.black54,
  context: context,
  builder: (context) => Dialog(
    backgroundColor: const Color(0xFF2C1E68),
    elevation: 5,
    child: Container(
      height: MediaQuery.of(context).size.height*0.35,
      width: MediaQuery.of(context).size.width*0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            decoration: BoxDecoration(
              border: Border.all(color: win == true? const Color(0xFF00e676) : Colors.red,style: BorderStyle.solid,width: 5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(win == true? Icons.check : const IconData(0xe16a, fontFamily: 'MaterialIcons'),color: win== true ? const Color(0xFF00e676): Colors.red,size: 100,),
          ),
          Text(word,
          style: TextStyle(color: win == true ? const Color(0xFF00e676) : Colors.red,fontSize: 32,fontWeight: FontWeight.w900,letterSpacing: 1),),
            MaterialButton(
            onPressed: ()async{
              setState(() {
                isButtonClickable = List.generate(26, (index) => true);
                word = words.getWord();
                wordHidden = words.getHiddenWord(word.length);
                if(win == true){
                  score++;
                  tries = 5;
                  isHintClickable = true;
                  Navigator.of(context).pop();
                }
                else{
                  if(life>0){
                  tries =5;
                  isHintClickable = true;
                  Navigator.of(context).pop();
                }
                else if(life<=0){
                  if(score > LandingScreen.highScore){
                  LandingScreen.highScore = score;
                  // using the intl package
                  final now = DateFormat('y-MMMM-d').format(DateTime.now());
                  FirebaseFirestore.instance.collection('HighScores').add({
                    'date' : now,
                    'score' : LandingScreen.highScore,
                  });
                  
                }
                isHintClickable = true;
                  scoreDialog();
                }
                }
              });
              
            },
            child: const Icon(Icons.arrow_right_alt,size: 50,color: Colors.white,),
            ),
          
        ],
      ),
    ),
  )
  );



// this dialog resets the game and tells u ur score and put it in the highScore page if its the highest
  Future scoreDialog()=> showDialog(
    // this property it doent make it possible to go back to what happens before the dialog pops up
    useRootNavigator: false,
    // this because u cant close the dialog unless you pressed the button
    barrierDismissible: false,
    context: context,
    builder: (context)=> Dialog(
      backgroundColor: const Color(0xFF2C1E68),
    elevation: 5,
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      height: MediaQuery.of(context).size.height*0.35,
      width: MediaQuery.of(context).size.width*0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Your score is:",
          style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
          Text("$score",
          style: const TextStyle(fontSize: 32,fontWeight: FontWeight.w900,color: Colors.white),),
          const Text("High score is:",
          style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
          Text("${LandingScreen.highScore}",
          style: const TextStyle(fontSize: 32,fontWeight: FontWeight.w900,color: Colors.white),),
          MaterialButton(
            onPressed: (){
              // print(highw);
              setState(() {
                score = 0;
                life = 5;
                tries = 5;
              });
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_right_alt,size: 50,color: Colors.white,),
            ),
        ],
      ),
      ),
    )
  );

// this dialog will pop when you ant to exit the game
Future<bool?> exitingTheGameDialog(BuildContext context) async => showDialog<bool>(
  context: context,
  builder: (context)=> AlertDialog(
    backgroundColor: const Color(0xFF2C1E68),
    title: const Column(
      children: [
        Text("Do you want to exit the game?",
        style: TextStyle(color: Colors.white,fontSize: 16),),
        Text("You will lose your score",
        style: TextStyle(color: Colors.white,fontSize: 26)),
      ],
    ),
    actions: [
      TextButton(
        onPressed:(){
          Navigator.pop(context, false);
        },
      child: const Text("No",
      style: TextStyle(color: Colors.white,fontSize: 20))),
      TextButton(
        onPressed:(){
          Navigator.pop(context, true);
        },
      child: const Text("Yes",
      style: TextStyle(color: Colors.white,fontSize: 20))),
    ],
  )
  ); 
  

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final dialog = await exitingTheGameDialog(context);
        return dialog ?? false;
      },
      child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.favorite,color: Colors.white,size: 39,),
                    Text('$life',style: const TextStyle(color: Color(0xFF421b9b),fontSize: 20,fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,)
                    
                  ],
                ),
                Text('$score',
                style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white,letterSpacing: 1),),
                
                // here it gives you a hint ... a free letter / letters
                IconButton(
                  onPressed:(){
                    if(isHintClickable == true){
                      String hintLetter  = '';
                        int i = 0;
                        while(i<word.length && wordHidden.contains(word[i].toUpperCase()) == true){
                          i++;
                        }
                        setState(() {
                        hintLetter = word[i];
                        for(int i=0;i<word.length;i++){
                          if(word[i] == hintLetter){
                            wordHidden = wordHidden.substring(0,i) + hintLetter.toUpperCase() + wordHidden.substring(i+1,wordHidden.length);
                          }
                        }
                        if(wordHidden.toLowerCase() == word){
                          win = true;
                          winOrLoseDialog();
                        }
                        isHintClickable = false;   
                      });
                    }
                  },
                  icon: Icon(Icons.lightbulb,size: 39,color: isHintClickable == true ? Colors.white : Colors.transparent,),
                  )
              ],
            ),
            ),
            
            Image(
              image: tries == 5 ? const AssetImage('images/0.png'):
                     tries == 4 ? const AssetImage('images/1.png'):
                     tries == 3 ? const AssetImage('images/2.png'):
                     tries == 2 ? const AssetImage('images/3.png'):
                     tries == 1 ? const AssetImage('images/4.png'):
                     tries == 0 ? const AssetImage('images/5.png'):
                     const AssetImage('images/6.png'),
              height: MediaQuery.of(context).size.height*0.3,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(wordHidden,
                style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w900,letterSpacing: 10),),
              ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5,0,5,0),
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                shrinkWrap: true,
                itemCount: 26,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  return Container(
                    margin: const EdgeInsets.fromLTRB(7, 5, 0, 0),
                    decoration: BoxDecoration(
                      color:isButtonClickable[index]? const Color(0xFF1089ff) : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      // color: isButtonClickable[index]? const Color(0xFF1089ff) : Colors.grey,
                      // height: 45,
                      // minWidth: 45,
                      // shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                      onPressed: isButtonClickable[index]?()=>whenButtonPressed(index): null,
                      child: Text(alphabet[index],
                      style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w900),),
                  ),
                );
                }
                ),
                ),
                // GridView.builder(
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                // shrinkWrap: true,
                // itemCount: 26,
                // physics: const NeverScrollableScrollPhysics(),
                // itemBuilder: (context,index){
                //   return Container(
                //     margin: const EdgeInsets.fromLTRB(5, 5, 0, 10),
                //     decoration: BoxDecoration(
                //       color:isButtonClickable[index]? const Color(0xFF1089ff) : Colors.grey,
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: TextButton(
                //       // color: isButtonClickable[index]? const Color(0xFF1089ff) : Colors.grey,
                //       // height: 45,
                //       // minWidth: 45,
                //       // shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                //       onPressed: isButtonClickable[index]?()=>whenButtonPressed(index): null,
                //       child: Text(alphabet[index],
                //       style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w900),),
                //   ),
                // );
                // }
                // ),
              
              
          ],
        ),
      ),
    ),
    );
  }
}