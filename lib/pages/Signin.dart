import 'package:chat_app/pages/ForgotPassword.dart';
import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/SignUp.dart';
import 'package:chat_app/server/database.dart';
import 'package:chat_app/server/preferencedshared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey=GlobalKey<FormState>();
String email ='',password='',name='',pic='',username='',id='';
final useremailcontroller = TextEditingController();
final userpasswordcontroller = TextEditingController();
Userlogin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  QuerySnapshot querySnapshot =await DatabaseMethods().getUserbyEmail(email);
  name="${querySnapshot.docs[0]["Name"]}";
  username ="${querySnapshot.docs[0]["username"]}";
  pic ="${querySnapshot.docs[0]["Photo"]}";
  id =querySnapshot.docs[0].id;
  await SharedPreferenceHelper().saveUserDisplayName(name);
  await SharedPreferenceHelper().saveUserName(username);
  await SharedPreferenceHelper().saveUserId(id);
  await SharedPreferenceHelper().saveUserPicKey(pic);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

  } on FirebaseAuthException catch(e){
if(e.code=='user-not-found'){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User found for this email",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
}else if(e.code=='wrong-password'){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Provided is wrong",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
}
  }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.deepPurple,
                        Colors.purple.shade400,
                        Colors.lightBlue
                      ], begin: Alignment.topLeft, end: Alignment.topRight),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 105))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "SignIn",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      )),
                      Center(
                          child: Text(
                        "Login to your account",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            margin:
                                EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            height: MediaQuery.of(context).size.height / 2.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 50,
                                    padding: EdgeInsets.only(left: 10,top: 3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black12)),
                                    child: TextFormField(
                                      controller: useremailcontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your email";
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.email)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 50,
                                    padding: EdgeInsets.only(left: 10,top: 3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black12)),
                                    child: TextFormField(
                                      controller: userpasswordcontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your email";
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.lock)),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgotpassword()));
                                      },
                                      child: Text(
                                        "Forgot Passowrd ?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      child: Material(
                                        elevation: 5,
                                        child: Center(

                                          child: Container(
                                            width: 140,
                                            padding: EdgeInsets.all(10),
                                            decoration:BoxDecoration(
                                              color: Colors.blueAccent,borderRadius: BorderRadius.circular(6)
                                            ) ,
                                            child: GestureDetector(
                                                onTap: (){
                                                  if(_formkey.currentState!.validate()){
                                                    setState(() {
          email = useremailcontroller.text;
          password =userpasswordcontroller.text;

                                                    });

                                                  };
                                                  Userlogin();
                                                },
                                                child: Center(child: Text("SignIn",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Don't have an Account?",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                              },
                              child: Text(" SignUp",style: TextStyle(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.bold),))
                      ],)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
