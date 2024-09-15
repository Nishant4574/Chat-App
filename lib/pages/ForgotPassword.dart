import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  String email='';
  final _formkey =GlobalKey<FormState>();
  final useremailcontroller =TextEditingController();

Resetpassword()async{
  try{
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Rest has been Sent",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }on FirebaseAuthException catch(e){
if(e.code=='user-not-found'){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User found for this email",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
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
                  height: MediaQuery.of(context).size.height / 1.5,
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
                            "Password Recovery",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          )),
                      Center(
                          child: Text(
                            "Enter your email",
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
                            height: MediaQuery.of(context).size.height / 3.8,
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
                                  SizedBox(height: 10,),

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
                                                      email =useremailcontroller.text;

                                                    });
Resetpassword();
                                                  }


                                                },
                                                child: Center(child: Text("Send Email",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),))),
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
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup()));
                              },
                              child: Text(" SignUp",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
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
