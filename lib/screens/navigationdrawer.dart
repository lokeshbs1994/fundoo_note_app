import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/archive_screen.dart';
import 'package:instagram_flutter/screens/remainder_screen.dart';

import '../model/user.dart';

class NavigationDrawer extends StatefulWidget {
  final User? user;
  const NavigationDrawer({Key? key, required this.user}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState(this.user);
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final User? user;

  _NavigationDrawerState(this.user);

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(user?.username ?? "User Name"),
        accountEmail: Text(user?.email ?? "Email"),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(user?.photoUrl ??
              "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
        ),
      ),
      const DrawerHeader(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          "Fundoo Notes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      listItem(
        icon: Icons.lightbulb_outline,
        text: 'Notes',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      Divider(),
      listItem(
        icon: Icons.notifications_outlined,
        text: 'Remainders',
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReminderScreen()));
        },
      ),
      Divider(),
      listItem(
        icon: Icons.archive_outlined,
        text: 'Archive',
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ArchiveScreen()));
        },
      ),
    ]));
  }

  Widget listItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
