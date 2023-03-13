import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:about/about.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/styles/dialogs.dart';
import '../res/styles/text_style.dart';
import '../res/styles/theme.dart';
import '../res/values/constants.dart';
import '../widgets/custom_button.dart';
import '../screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/bicycle.svg',
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  _auth.currentUser.displayName,
                  textAlign: TextAlign.center,
                  style: kDisplayNameTextStyle,
                ),
                const SizedBox(height: 5),
                const Text(
                  'The tasrufdar',
                  style: kAppDisplayNameTextStyle,
                ),
                const SizedBox(
                  height: 10.0,
                  width: 150.0,
                  child: Divider(color: Colors.white),
                ),
              ],
            ),
          ),
          DrawerTile(
            icon: FontAwesome.github,
            label: 'Make a contribution',
            onPressed: () async {
              final Uri url = Uri.parse(kGithubRepoUrl);
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          DrawerTile(
            icon: Icons.email,
            label: 'Drop a mail',
            onPressed: () async {
              final Uri url = Uri(path: kGmailURL, scheme: 'mailto');
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          DrawerTile(
            icon: FontAwesome.linkedin,
            label: 'Connect with me',
            onPressed: () async {
              final Uri url = Uri.parse(kLinkedInUrl);
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          DrawerTile(
            icon: MaterialIcons.share,
            label: 'Share this app',
            onPressed: () async {
              Share.share(
                "Tasruf is Kashmir's first open-chat app.\nFork it on GitHub: $kGithubRepoUrl\nDownload app: $kGooglePlayStoreLink ",
                subject: 'Tasruf',
              );
            },
          ),
          const LicensesPageListTile(
            title: Text('Open source licenses'),
            icon: Icon(Icons.favorite),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: CustomButton(
              label: 'Logout',
              colorList: const [Color(0XFFEF9A9A), kAccentColor],
              onPressed: () {
                awesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  title: 'Logout: ',
                  cancelPress: () {},
                  okPress: () {
                    _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.id,
                      (route) => false,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;
  const DrawerTile({Key key, this.icon, this.label, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
      ),
    );
  }
}
