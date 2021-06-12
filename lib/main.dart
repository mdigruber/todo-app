import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:to_do_app/misc/helper.dart';
import 'completed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: TodoList(title: 'To-Do App'),
    );
  }
}

class TodoList extends StatefulWidget {
  TodoList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });
  }

  void deleteEntry(int index) {
    setState(() {
      openTodos.removeAt(index);
    });
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompletedTasks()),
      );
    }
  }

  TextEditingController txtController(String text) {
    var textController = TextEditingController(text: text);
    return textController;
  }

  void addEntry() {
    setState(() {
      openTodos.insert(0, "Neuer Eintrag");
    });
  }

  Future<void> fetchData() async {
    final String url = "https://jsonplaceholder.typicode.com/todos";
    Response response = await get(Uri.parse(url));
    List decoded = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        decoded.asMap().forEach((index, element) {
          if (index <= 10) openTodos.add(element['title']);
        });
      });
    } else {
      setState(() {
        openTodos.add("Bitte Internetverbindung überprüfen");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        // Button for adding new To-DO
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              addEntry();
            });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //Body
        body: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints.expand(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: ListView(
              children: [
                for (int index = 0; index < openTodos.length; index++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (index + 1).toString() + ".",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: TextField(
                            controller: txtController(openTodos[index]),
                            onChanged: (text) {
                              changeEntry(index, text);
                            },
                            style: TextStyle(fontSize: 16),
                          )),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                deleteEntry(index);
                              },
                              child: Icon(Icons.delete)),
                          ElevatedButton(
                              onPressed: () {
                                addCompletedTodo(openTodos[index]);
                                deleteEntry(index);
                              },
                              child: Icon(Icons.check))
                        ],
                      ),
                    ],
                  ),
              ],
            )),
          ]),
        ),
        //Bottom Navigator
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.note_sharp),
                label: openTodos.length.toString() + " Tasks noch offen",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check),
                label:
                    completedTodos.length.toString() + " Tasks abgeschlossen",
              )
            ],
          ),
        ));
  }
}
