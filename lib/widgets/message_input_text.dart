import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../res/styles/decoration.dart';
import '../res/styles/text_style.dart';
import '../res/styles/theme.dart';

class MessageInputText extends StatefulWidget {
  final String replyTo;
  final String replyingTo;
  final Function prepareReply;
  
  MessageInputText(
    this.replyTo,
    this.prepareReply,
    this.replyingTo,
  );
  @override
  _MessageInputTextState createState() => _MessageInputTextState();
}

class _MessageInputTextState extends State<MessageInputText> {
  final userRef = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  final messageTextController = TextEditingController();
  String messageText;

  @override
  Widget build(BuildContext context) {
    return widget.replyTo.isEmpty ? buildInputField(context) : buildInputForReply(context);
  }

  Widget buildInputForReply(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: const BoxConstraints(minHeight: 60),
          width: double.infinity,
          decoration: kMessageInputBarDecoraton,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.reply),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4),
                      child: Text(widget.replyingTo, style: kPrimaryColoredTextStyleBig),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5),
                      child: Text(
                        widget.replyTo,
                        style: secondaryTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => widget.prepareReply('', ''),
                icon: const Icon(Icons.cancel),
              ),
            ],
          ),
        ),
        buildInputField(context),
      ],
    );
  }

  Widget buildInputField(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              autofocus: widget.replyTo.isNotEmpty ? true : false,
              controller: messageTextController,
              enableSuggestions: true,
              decoration: kMessageTextFieldDecoration,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 25),
            icon: const Icon(
              FontAwesome.send,
              color: kPrimaryColor,
            ),
            onPressed: () {
              messageText = messageTextController.text.trim();
              if (messageText != '') {
                userRef.collection('messages').add(
                  {
                    'id': _user.uid,
                    'sender': _user.displayName,
                    'text': messageText,
                    'time': DateTime.now(),
                    'replyTo': widget.replyTo ?? '',
                    'replyingTo': widget.replyingTo,
                  },
                );
              }
              messageTextController.clear();
              widget.prepareReply('', '');
            },
          ),
        ],
      ),
    );
  }
}
