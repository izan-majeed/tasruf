import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../res/styles/text_style.dart';
import '../res/styles/theme.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final text;
  final bool isMe;
  final Timestamp time;
  final String replyTo;
  final Function prepareReply;
  final String replyingTo;

  const MessageBubble({
    Key key,
    this.sender = '',
    this.text,
    this.isMe,
    this.time,
    this.replyTo,
    this.prepareReply,
    this.replyingTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double left = isMe ? 60 : 10;
    final double right = isMe ? 10 : 60;

    return replyTo.isEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                buildTimeStamp(context),
                SwipeTo(
                  onRightSwipe: () {
                    prepareReply(text.text, sender);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(left, 0, right, 0),
                      child: buildMessageBubble(context),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                buildTimeStamp(context),
                SwipeTo(
                  onRightSwipe: () {
                    prepareReply(text.text, sender);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(left, 0, right, 0),
                          child: buildMessageBubbleWithReply(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildMessageBubbleWithReply(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: getPaddingforMessageBubble(isMe),
        color: !isMe ? kAccentColor : kSenderBubbleColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
              color: !isMe ? kAccentColor : kSenderBubbleColor,
              border: Border(
                left: BorderSide(
                  color: isMe ? kAccentColor : kSenderBubbleColor,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  replyingTo,
                  style: const TextStyle(
                    fontSize: 15,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  replyTo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          text,
        ],
      ),
    );
  }

  Widget buildTimeStamp(BuildContext context) {
    final t = time.toDate();
    final double left = isMe ? 60 : 10;
    final double right = isMe ? 10 : 60;
    return Container(
      padding: EdgeInsets.fromLTRB(left, 0, right, 0),
      child: Text(
        '${sender.split(' ')[0]} at ${t.hour}:${t.minute}',
        style: primaryTextStyleSmaller,
      ),
    );
  }

  Widget buildMessageBubble(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: isMe ? kSenderBubbleColor : kAccentColor,
            borderRadius: getPaddingforMessageBubble(isMe),
          ),
          child: text,
        ),
      ],
    );
  }

  BorderRadius getPaddingforMessageBubble(isMe) {
    return isMe
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          );
  }
}
