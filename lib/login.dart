import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {

    Color secondary = Color(0xFFECEFF1);
    Color primary = Color(0xFF343341);
    Color primary_background = Color(0xFFF1F4F8);
    Color secondary_background = Color(0xFFFFFFFF);
    Color alternate = Color(0xFFE0E3E7);
    Color secondary_Text = Color(0xFF57636C);
    Color success = Color(0xFF249689);
    Color gehna = Color(0xFF03473F);
    Color heart = Color(0xFFFFB0909);


    return Scaffold(
      backgroundColor: Colors.white ,
      body: SafeArea(
        child : Column(
        children: [
          //Back Button
          Padding(
            padding: EdgeInsets.only(top: 25, left: 20),
            child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: alternate, 
                width: 2,

              )
            ),

            child: Icon(Icons.arrow_back_ios_new_rounded, color: primary, 
            size: 30,),
          ),
          ),
        
          //Dp
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(360)
            ),
          )
        
        ],
      ),
    ),
    );
  }
}
