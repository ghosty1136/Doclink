import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 2000),(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ,));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:
      Center(
      child: Image(
        image: AssetImage('assets/images/icon.png'),
        height: 150,
        width: 150,
      ),
    ),
    );
  }
}
