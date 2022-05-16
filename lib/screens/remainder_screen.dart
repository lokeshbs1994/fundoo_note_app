import 'package:flutter/material.dart';

import '../model/user.dart';
import '../resources/auth_methods.dart';
import 'navigationdrawer.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    user = await AuthMethods.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white10,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Material(
                          color: Colors.white10,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      size: 25,
                                    ),
                                    color: Colors.black.withOpacity(0.7),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                Text(
                                  "Reminders",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(width: 140.0),
                                IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      size: 25,
                                    ),
                                    color: Colors.black.withOpacity(0.7),
                                    onPressed: () {
                                      TextFormField(
                                          decoration: InputDecoration.collapsed(
                                            hintText: "Search your notes",
                                          ),
                                          onChanged: (value) {});
                                    }),
                                SizedBox(width: 2.0),
                                IconButton(
                                    icon: Icon(
                                      Icons.view_agenda_outlined,
                                      size: 25,
                                    ),
                                    color: Colors.black.withOpacity(0.7),
                                    onPressed: () {}),
                                SizedBox(width: 2.0)
                              ])))))),
      drawer: NavigationDrawer(
        user: user,
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.notifications_outlined,
          size: 100,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Notes with upcoming reminders appear here"),
      ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
      ),
    );
  }
}
