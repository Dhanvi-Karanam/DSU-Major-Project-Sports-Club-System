import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_management_updated/user_login/register.dart';

import '../mainscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey=GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
              opacity:0.3,
              fit: BoxFit.fill
          ),

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Form(
              key:_formkey,
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0,),
                    child: Container(
                      child: Image.asset('assets/logo2.png'),

                    ),
                  ),


                    TextFormField(
                      controller: emailcontroller,
                      validator:(value){
                        if(value==null || value==''){
                          return 'Please enter valid username';
                        }
                      } ,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Colors.grey,size: 15,),
                      contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                    child: TextFormField(
                      controller: passwordcontroller,
                      validator:(value){
                        if(value==null || value==''){
                          return 'Please enter valid password';
                        }
                      } ,
                      obscureText: true,
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,color: Colors.grey,size: 15,),
                        contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 168.0,bottom: 20),
                    child: Text( 'Forgot Password',style: TextStyle(color: Colors.white,decoration: TextDecoration.underline)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5252),
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
                        ),
                          onPressed: (){
                            if (_formkey.currentState!.validate()) {
                              gotologin(emailcontroller.text,passwordcontroller.text);
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              //ScaffoldMessenger.of(context).showSnackBar(
                                //const SnackBar(content: Text('Homescreen coming soon')),
                              //);

                            }

                          },
                          child: Text('Login'),
                      )
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color:Colors.redAccent.shade200,width:2),
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Register()),
                          );

                        },
                        child: Text('Register',style: TextStyle(color: Colors.redAccent.shade200,),),
                      )
                  )


                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  gotologin(email,password) async{
    print('login');
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$email",
          password: "$password"
      );
      print('success of login ${userCredential.credential}');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx)=> Homescreen()), (route) => false);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context)=> Homescreen())
      // );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');

      }
    }
  }
}
