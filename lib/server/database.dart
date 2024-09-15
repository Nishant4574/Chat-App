import 'package:chat_app/server/preferencedshared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .where("E-mail", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  CreateChatRoom(
      String ChatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(ChatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(ChatRoomId)
          .set(chatRoomInfoMap);
    }
  }
  Future addMeassage(String ChatRoomId,String messageId,Map<String ,dynamic>messageInoMap)async{
    return FirebaseFirestore.instance.collection('chatrooms').doc(ChatRoomId).collection('chats').doc(messageId).set(messageInoMap);
  }
  UpdateLastMessageSend(String ChatRoomId,Map<String,dynamic>lastMessageInfoMap)async{
    return FirebaseFirestore.instance.collection("chatrooms").doc(ChatRoomId).update(lastMessageInfoMap);
  }
  Future<Stream<QuerySnapshot>> getChatRoomMessage(ChatRommId)async{
    return FirebaseFirestore.instance.collection("chatrooms").doc(ChatRommId).collection("chats").orderBy("time",descending:true ).snapshots();
  }
  Future<QuerySnapshot> getUserbyUsername(String username)async{
    return await FirebaseFirestore.instance.collection("user").where('username',isEqualTo:username).get();
  }
  Future<Stream<QuerySnapshot>> getChatRooms()async{
    String? myUsername =await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance.collection('chatrooms').orderBy('time',descending: true).where('user',arrayContains: myUsername!.toUpperCase()).snapshots();
  }
}
