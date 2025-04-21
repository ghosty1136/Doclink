import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:kodoctor/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PassController = TextEditingController();
  TextEditingController _CPassController = TextEditingController();

  Color secondary = Color(0xFFECEFF1);
  Color primary = Color(0xFF343341);
  Color primary_background = Color(0xFFF1F4F8);
  Color secondary_background = Color(0xFFFFFFFF);
  Color alternate = Color(0xFFE0E3E7);
  Color secondary_Text = Color(0xFF57636C);
  Color success = Color(0xFF249689);
  Color gehna = Color(0xFF03473F);
  Color heart = Color(0xFFFFB0909);

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoginPage = true;
  bool isContinued = false;

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Back Button
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: alternate, width: 2),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primary,
                    size: 20,
                  ),
                ),
              ),
              //Dp
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Image(
                        image: AssetImage('assets/images/icon.png'),
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
              //login layout
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 40),
                child: Text(
                  isLoginPage ? 'Login' : 'SignUp',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5),
                child: Text(
                  isLoginPage
                      ? 'Login to continue with Doclink'
                      : 'Create account with Doclink',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontFamily: 'Redex',
                  ),
                ),
              ),
              //Email TextEditor
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    style: TextStyle(
                      color: primary,
                      fontFamily: 'Redex',
                      fontSize: 16,
                    ),

                    keyboardType: TextInputType.emailAddress,

                    controller: _EmailController,
                    decoration: InputDecoration(
                      //Hint Text
                      label: Text(
                        'Enter your Email',
                        style: TextStyle(fontSize: 15, fontFamily: 'Redex'),
                      ),

                      prefixIcon: Icon(Icons.email_rounded),

                      fillColor: Colors.grey.shade50,
                      filled: true,

                      // Normal Border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: secondary_Text, width: 3),
                      ),
                      // Focused Border
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(360),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      //Enabled Border
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(360),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Password
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    style: TextStyle(
                      color: primary,
                      fontFamily: 'Redex',
                      fontSize: 16,
                    ),
                    obscuringCharacter: '*',
                    obscureText: true,
                    controller: _PassController,

                    decoration: InputDecoration(
                      //Hint Text
                      label: Text(
                        'Enter Password',
                        style: TextStyle(fontSize: 15, fontFamily: 'Redex'),
                      ),

                      prefixIcon: Icon(Icons.password_rounded),

                      fillColor: Colors.grey.shade50,
                      filled: true,

                      // Normal Border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: secondary_Text, width: 3),
                      ),
                      // Focused Border
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(360),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      //Enabled Border
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(360),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Confirm Password
              Visibility(
                visible: !isLoginPage,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: SizedBox(
                    height: 60,
                    child: TextFormField(
                      style: TextStyle(
                        color: primary,
                        fontFamily: 'Redex',
                        fontSize: 16,
                      ),
                      obscuringCharacter: '*',
                      obscureText: true,
                      controller: _CPassController,

                      decoration: InputDecoration(
                        //Hint Text
                        label: Text(
                          'Confirm Password',
                          style: TextStyle(fontSize: 15, fontFamily: 'Redex'),
                        ),

                        prefixIcon: Icon(Icons.password_rounded),

                        fillColor: Colors.grey.shade50,
                        filled: true,

                        // Normal Border
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: secondary_Text,
                            width: 3,
                          ),
                        ),
                        // Focused Border
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(360),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        //Enabled Border
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(360),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Login btn
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 55),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        CupertinoDynamicColor.withBrightness(
                          color: Colors.blue,
                          darkColor: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (isLoginPage) {
                        //login
                        if (_EmailController.text != '') {
                          //email entered
                          if (_PassController.text != '') {
                            //password entered

                            isContinued = true;
                            setState(() {});

                            try {
                              UserCredential UserCred = await _auth
                                  .signInWithEmailAndPassword(
                                    email: _EmailController.text,
                                    password: _PassController.text,
                                  );

                              if (UserCred.user != null) {
                                //loggedin successfully
                                _showMsg('Successfully LoggedIn');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              _showMsg('$e');
                              isContinued = false;
                              setState(() {});
                            }
                          } else {
                            //password empty
                            _showMsg('Enter Password!');
                          }
                        } else {}
                      } else {
                        isContinued = true;
                        setState(() {});
                        //Signup

                        if (_EmailController.text != '') {
                          //email entered
                          if (_PassController.text != '') {
                            //password entered
                            if (_PassController.text == _CPassController.text) {
                              //matched
                              try {
                                UserCredential UserCred = await _auth
                                    .createUserWithEmailAndPassword(
                                      email: _EmailController.text,
                                      password: _PassController.text,
                                    );
                                if (UserCred.user != null) {
                                  //loggedin successfully
                                  isContinued = false;
                                  setState(() {});
                                  _showMsg('Successfully SignUp');
                                }
                              } on FirebaseAuthException catch (e) {
                                isContinued = false;
                                setState(() {});
                                _showMsg('$e');
                              }
                            } else {
                              //pass not equal confirm pass
                              _showMsg('Password doesn`t match');
                            }
                          }
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isContinued,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                             child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          isContinued
                              ? 'Loading....'
                              : isLoginPage
                              ? 'Login Now'
                              : 'SignUp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Visibility(
                          visible: !isContinued,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Center(
                  child: Text(
                    'Or',
                    style: TextStyle(
                      color: secondary_Text,
                      fontSize: 20,
                      fontFamily: 'Redex',
                    ),
                  ),
                ),
              ),
              //google btn
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(color: alternate, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 12),
                        child: Image(
                          image: AssetImage('assets/images/google.png'),
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.blueGrey.shade700,
                          fontSize: 18,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Signup btn
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 30),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      isLoginPage = !isLoginPage;
                      setState(() {});
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                isLoginPage
                                    ? 'Don`t have account ?'
                                    : 'Already have an account : ',
                            style: TextStyle(
                              color: primary,
                              fontSize: 17,
                              fontFamily: 'Redex',
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          TextSpan(
                            text: isLoginPage ? 'SignUp' : 'Login',
                            style: TextStyle(
                              color: CupertinoColors.systemBlue,
                              fontSize: 17,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
