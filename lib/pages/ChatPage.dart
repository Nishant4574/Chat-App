import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/server/database.dart';
import 'package:chat_app/server/preferencedshared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Chatpage extends StatefulWidget {
  final String name, profileurl, username;

  Chatpage({
    super.key,
    required this.name,
    required this.profileurl,
    required this.username,
  });

  @override
  State createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final messagecontroller = TextEditingController();
  String? myUserName, myProfilePic, myName, myEmail, messageID, ChatRoomId;
  Stream? messsageStream;

  @override
  void initState() {
    super.initState();
    onload();
  }

  onload() async {
    await getSharedPref();
    await getandsetmesaage();
    setState(() {});
  }

  getSharedPref() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    myProfilePic = await SharedPreferenceHelper().getUserPicKey();
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    ChatRoomId = await getCharRoomIdByUsername(widget.username, myUserName!);
    setState(() {});
  }

  getCharRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatMessageTitle(String message, bool sendbyme) {
    return Row(
      mainAxisAlignment: sendbyme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight: sendbyme ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sendbyme ? Radius.circular(24) : Radius.circular(0),
              ),
              color: sendbyme ? Colors.grey.shade300 : Colors.blue,
            ),
            child: Text(
              message,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  getandsetmesaage() async {
    messsageStream = await DatabaseMethods().getChatRoomMessage(ChatRoomId);
    setState(() {});
  }

  Widget chatmessage() {
    return StreamBuilder(
      stream: messsageStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            padding: EdgeInsets.only(bottom: 90, top: 130),
            reverse: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              print("Chat message is ${ds['message']}");
              return chatMessageTitle(ds["message"], myUserName == ds["sendBy"]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  AddMessage(bool sendClick) {
    if (messagecontroller.text != "") {
      String messages = messagecontroller.text;
      messagecontroller.clear();
      DateTime now = DateTime.now();
      String formateDate = DateFormat('h:mma').format(now);

      Map<String, dynamic> messagesInfo = {
        "message": messages,
        "sendBy": myUserName,
        "ts": formateDate,
        'time': FieldValue.serverTimestamp(),
        'imgUrl': myProfilePic
      };

      messageID ??= randomAlpha(10);
      DatabaseMethods().addMeassage(ChatRoomId!, messageID!, messagesInfo).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "LastMessage": messages,
          "LastMessageSendTime": formateDate,
          "time": FieldValue.serverTimestamp(),
          "LastMessageSendby": myUserName,
        };
        DatabaseMethods().UpdateLastMessageSend(ChatRoomId!, lastMessageInfoMap);
        if (sendClick) {
          messageID = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: chatmessage(),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: messagecontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                AddMessage(true);
                              },
                              child: Icon(Icons.send),
                            ),
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.black45),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
