import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/server/database.dart';
import 'package:chat_app/server/preferencedshared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? ChatRoomStream;
  List queryResultSet = [];
  List tempSearchStore = [];

  @override
  void initState() {
    super.initState();
    onLoad();
  }

 getSharedPref() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myUserName = await SharedPreferenceHelper().getUserName();
    myProfilePic = await SharedPreferenceHelper().getUserPicKey();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  onLoad() async {
    ChatRoomStream =await DatabaseMethods().getChatRooms();
    await getSharedPref();
  }

  String getCharRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Future<void> initialSearch(String value) async {
    if (value.isEmpty) {
      setState(() {
        queryResultSet.clear();
        tempSearchStore.clear();
      });
      return;
    }

    setState(() {
      search = true;
    });

    String capitalizedValue = value.toUpperCase();

    if (queryResultSet.isEmpty) {
      QuerySnapshot docs = await DatabaseMethods().Search(capitalizedValue);
      setState(() {
        queryResultSet = docs.docs.map((doc) => doc.data()).toList();
      });
    } else {
      setState(() {
        tempSearchStore = queryResultSet
            .where((element) =>
            (element['username'] as String)
                .contains(capitalizedValue))
            .toList();
      });
    }
  }

Widget ChatRoomListStream(){
    return StreamBuilder(stream: ChatRoomStream, builder: (context,AsyncSnapshot snapshot){
return snapshot.hasData?ListView.builder(
    itemCount: snapshot.data!.docs.length,
    shrinkWrap: true,
    itemBuilder: (context,index){
  DocumentSnapshot ds =snapshot.data!.docs[index];
  return ChatRoomList(lastMessage: ds['LastMessage'], chatRoomId: ds.id, myUsername: myUserName!, time: ds["LastMessageSendTime"]);
}):Center(child: Container());
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: TextFormField(
                          onChanged: initialSearch,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Text(
                        "ChatUp",
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      search = !search;
                    });
                  },
                  child: Container(
                    height: 20,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      search ? Icons.close : Icons.search,
                      color: Colors.grey,
                      size: 29,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: search
                  ? ListView.builder(
                      itemCount: tempSearchStore.length,
                      itemBuilder: (context, index) {
                        return buildCard(tempSearchStore[index]);
                      },
                    )
                  : ChatRoomListStream()
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          search = false;
        });
        var chatRoomId = getCharRoomIdByUsername(myUserName!, data['username']);
        Map<String, dynamic> chatRoomInfoMap = {
          "user": [myUserName, data["username"]]
        };
        await DatabaseMethods().CreateChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatpage(
              name: data["Name"],
              profileurl: data["Photo"],
              username: data["username"],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data["Photo"],
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    )),
                SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['Name'],
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['username'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ChatRoomList extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  const ChatRoomList({
    super.key,
    required this.lastMessage,
    required this.chatRoomId,
    required this.myUsername,
    required this.time,
  });

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  String profilePicUrl = "", name = "", username = " ", id = "";

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  getThisUserInfo() async {
    username = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =
    await DatabaseMethods().getUserbyUsername(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatpage(
              name: name,
              profileurl: profilePicUrl,
              username: username,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            profilePicUrl == ""
                ? CircularProgressIndicator()
                : ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  profilePicUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.lastMessage,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


