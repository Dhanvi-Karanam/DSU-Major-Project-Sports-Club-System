import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_management_updated/user_login/signin.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            image: const DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                opacity: 0.4,
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 28.0,
                  ),
                  child: Container(
                    child: Image.asset('assets/logo2.png'),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 15,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: TextFormField(
                    //obscureText: true,
                    controller: emailcontroller,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                        size: 15,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: TextFormField(
                    //obscureText: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey,
                        size: 15,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 15,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: TextFormField(
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 15,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      hintText: 'Re-enter Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5252),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)))),
                      onPressed: () {
                        doToRegister(
                            emailcontroller.text, passwordcontroller.text);
                      },
                      child: const Text('Sign up'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doToRegister(email, password) async {
    try {
      print('inside register email->$email,password->$password');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: '$email', password: '$password');
      print('This is user credential SUCCESS ${userCredential.credential}');
      Navigator.push(context, MaterialPageRoute(builder: (ctx)=> LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('indside catch');
      print(e);
    }
  }
}
