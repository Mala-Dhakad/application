import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfirstapp/firstscreenexample.dart';
import 'package:myfirstapp/logintaskexample.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplaceScreen extends StatefulWidget {
  @override
  State<SplaceScreen> createState() => _SplacescreenState();
}
class _SplacescreenState extends State<SplaceScreen> {

 String loginStatus="";
  @override
  void initState() {
    getPrefData();
    super.initState();

  }
 navigatePage()  {

   print("------loginStatus--" + loginStatus.toString());

   if(loginStatus=="1")
   {
     Timer(
         Duration(seconds: 3),
             () => Navigator.pushReplacement(
             context, MaterialPageRoute(builder: (context) => HomePage())));

   }

   else{
     Timer(Duration(seconds: 5), () {

       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) =>LoginExample()),
       );
     });

 }}

  void getPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = pref.getString("loginStatus")??"";

    });


    navigatePage();

  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/splace.jpg"),),
SizedBox(height: 20,),
            Text('WELCOME TO THIS APP',style: TextStyle(fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            ),),
          ],
        ),
      ),
    );
  }
}
