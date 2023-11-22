import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

import '../providers/theme_provider.dart';
import '../res/styles/theme.dart';
import '../widgets/message_input_text.dart';
import '../widgets/message_stream.dart';
import '../widgets/custom_drawrer.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool switchValue = true;
  String replyTo = '';
  String replyingTo = '';

  ParticleOptions particleOptions = const ParticleOptions(
    baseColor: kAccentColor,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.3,
    maxOpacity: 0.7,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  void prepareReply(String message, String username) {
    setState(() {
      replyTo = message.length > 100 ? '${message.substring(0, 100)}..' : message;
      replyingTo = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: const CustomDrawer(),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
        ),
        vsync: this,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(prepareReply: prepareReply),
            MessageInputText(
              replyTo: replyTo,
              replyingTo: replyingTo,
              prepareReply: prepareReply,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('loading...');
            return Text(
              "${snapshot.data!.docs.length} Tasrufdars",
              style: const TextStyle(
                color: Colors.white,
              ),
            );
          }),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => Switch(
            activeColor: kAccentColor,
            value: switchValue,
            onChanged: (toggle) {
              setState(
                () {
                  switchValue = toggle;
                  themeProvider.switchTheme();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
