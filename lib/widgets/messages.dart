import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats').orderBy('createdAt', descending: true)
            .snapshots(),
        // stream is connected to the snapShot.
        builder: (ctx, snapShot) {
          //print(snapShot.data.docs[0]['userName']);
          final docs = snapShot.data.docs;
          final user = FirebaseAuth.instance.currentUser;
          if (snapShot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                docs[index]['text'],
                docs[index]['userName'],
                docs[index]['userId'] == user.uid, // this determines the 'isMe' value.
                key: ValueKey(docs[index]['userId']),
              ));
        });
  }
}

/*
ListView.builder(
            reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                  docs[index]['text'],
                docs[index]['userName'],
                docs[index]['userId'] == user.uid, // this determines the 'isMe' value.
                key: ValueKey(docs[index]['userId']),
              ))
*/
