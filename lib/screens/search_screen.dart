import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/database_manager.dart';
import 'package:instagram_flutter/resources/sqlflite_manager.dart';
import '../model/note.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Note> notes = [];
  String searchString = "";
  List<Note> filteredNotes = [];
  final TextEditingController _searchStringController = TextEditingController();

  @override
  void initState() {
    fetchNotes();

    super.initState();
  }

  fetchNotes() async {
    notes = await DatabaseManager.getInstance().getAllNotes();
    setState(() {});
  }

  void searchResults(String searchString) {
    filteredNotes.clear();
    filteredNotes = notes
        .where((element) =>
            element.title.toLowerCase().contains(searchString) ||
            element.content.toLowerCase().contains(searchString))
        .toList();
    if (searchString == "") {
      filteredNotes.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
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
                    Expanded(
                        child: TextField(
                      onChanged: ((value) {
                        setState(() {
                          searchResults(value.toLowerCase());
                        });
                      }),
                      controller: _searchStringController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 70, top: 15),
                        hintText: "Search your notes",
                      ),
                    )),
                  ],
                ),
              ),
            ),
          )),
      body: ListView.separated(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
