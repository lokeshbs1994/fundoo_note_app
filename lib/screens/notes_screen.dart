import 'package:flutter/material.dart';

import 'package:instagram_flutter/resources/auth_methods.dart';

import 'package:instagram_flutter/screens/addNote.dart';

import 'package:instagram_flutter/screens/navigationdrawer.dart';
import 'package:instagram_flutter/screens/search_screen.dart';
import 'package:instagram_flutter/views/grid_view_notes.dart';
import 'package:instagram_flutter/views/list_view_notes.dart';

import '../model/user.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool view = false;
  User? user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.black,
        //title: Text('Fundoo notes'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 12),
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 69, 61, 61),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.dehaze,
                      size: 30,
                    ),
                    color: Colors.white.withOpacity(0.7),
                    onPressed: () {
                      if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                        _scaffoldKey.currentState?.openDrawer();
                      } else {
                        _scaffoldKey.currentState?.openEndDrawer();
                      }
                    },
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text("Search"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        view ? Icons.list_rounded : Icons.grid_view_outlined),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        view = !view;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      bool isLoggedOut = await AuthMethods.signOut();
                      // if(isLoggedOut){
                      //  Navigator.pushReplacement(context, );
                      // }
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user?.photoUrl ??
                          "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: NavigationDrawer(
        user: user,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
      ),
      key: _scaffoldKey,
      body: _changeView(),
    );
  }

  _changeView() {
    if (view == true) {
      return const GridViewNotes();
    } else {
      return const ListViewNotes();
    }
  }
}
