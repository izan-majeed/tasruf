import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/message_bubble.dart';
import '../res/styles/text_style.dart';

class MessagesStream extends StatelessWidget {
  final prepareReply;
  const MessagesStream(this.prepareReply, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userRef = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: userRef
          .collection('messages')
          .orderBy(
            'time',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return (snapshot.data.docs.isEmpty) ? buildNoChatsFound(context) : buildChat(context, snapshot, auth);
      },
    );
  }

  Widget buildChat(BuildContext context, snapshot, auth) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
        shrinkWrap: true,
        reverse: true,
        itemCount: snapshot.data.docs.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot message = snapshot.data.docs[index];

          var replyTo;
          try {
            replyTo = message['replyTo'];
          } catch (error) {
            replyTo = '';
          }
          var replyingTo;
          try {
            replyingTo = message['replyingTo'];
          } catch (error) {
            replyingTo = 'Unknown';
          }

          return MessageBubble(
            sender: message['sender'],
            text: SelectableLinkify(
                text: message['text'],
                style: primaryTextStyle,
                onTap: () async {
                  try {
                    await launchUrl(
                      Uri.parse(message['text']),
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {}
                }),
            isMe: (auth.currentUser.uid == message['id']),
            time: message['time'],
            replyTo: replyTo.length < 63 ? replyTo : replyTo.substring(0, 60),
            prepareReply: prepareReply,
            replyingTo: replyingTo,
          );
        },
      ),
    );
  }

  Widget buildNoChatsFound(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
      child: SvgPicture.asset(
        'assets/images/empty.svg',
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );
  }
}
