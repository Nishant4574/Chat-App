import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/Signin.dart';
import 'package:chat_app/server/database.dart';
import 'package:chat_app/server/preferencedshared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
final _formkey =GlobalKey<FormState>();
  String name='',email ="",password="",confirmPassword='';
  final emailcontroller =TextEditingController();
  final passwordcontroller =TextEditingController();
  final namecontroller =TextEditingController();
  final confirmpassowrdcontroller =TextEditingController();

  registration()async{
    if(password!=null&&password==confirmPassword){
      try{
        UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String id =randomNumeric(10);
        String user =emailcontroller.text.replaceAll("@gmail.com", "");
        String updateusername = user.replaceFirst(user[0], user[0].toUpperCase());
        String filterletter =user.substring(0,1).toUpperCase();

        Map<String,dynamic>userInfoMap={
'Name':namecontroller.text,
          'E-mail':emailcontroller.text,
          'username':updateusername.toUpperCase(),
          "SearchKey":filterletter,
          "Photo":"https://img.freepik.com/free-photo/handsome-confident-smiling-man-with-hands-crossed-chest_176420-18743.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1723939200&semt=ais_hybrid",
        "Id":id
        };
        await DatabaseMethods().addUserDetails(userInfoMap, id);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(emailcontroller.text);
        await SharedPreferenceHelper().saveUserPicKey("https://img.freepik.com/free-photo/handsome-confident-smiling-man-with-hands-crossed-chest_176420-18743.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1723939200&semt=ais_hybrid");
        await SharedPreferenceHelper().saveUserName(emailcontroller.text.replaceAll("@gmail.com", ""));


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successfull",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }on FirebaseAuthException catch(e){
        if(e.code=='weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Provided is too weak",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
        }else if(e.code=='email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Already exist",style: TextStyle(fontSize: 20),),backgroundColor: Colors.red,));
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          )),
                      Center(
                          child: Text(
                            "SignUp to your new account",
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
                            height: MediaQuery.of(context).size.height / 1.7,
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
                                    "Name",
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
                                      controller: namecontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your name";
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.person)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
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
                                      controller: emailcontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your email-ID";
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
                                      controller: passwordcontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your Password";
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.lock)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Confirm Password",
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
                                      controller: confirmpassowrdcontroller,
                                      validator: (value){
                                        if(value==null||value.isEmpty){
                                          return "Please Enter your confirm password";
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.lock)),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                              
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(onTap: (){
                                    if(_formkey.currentState!.validate()){
                                 setState(() {
                                   email=emailcontroller.text;
                                   name=namecontroller.text;
                                   password =passwordcontroller.text;
                                   confirmPassword =confirmpassowrdcontroller.text;
                                 });
                                    };
                                    registration();
                                  },
                                    child: Center(
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
                                              child: Center(child: Text("SignUp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
                                            ),
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
                          Text("Already have an account?",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Signin()));
                              },
                              child: Text(" SignIn",style: TextStyle(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.bold),))
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
