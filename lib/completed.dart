import 'package:flutter/material.dart';
import 'package:to_do_app/misc/helper.dart';

class CompletedTasks extends StatefulWidget {
  CompletedTasks({Key? key}) : super(key: key);

  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  int _currentIndex = 1;

  void onTabTapped(int index) {
    if (index != 1) {
      Navigator.pop(context);
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void deleteCompletedEntry(int index) {
    setState(() {
      completedTodos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Abgeschlossene Tasks"),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    for (int index = 0; index < completedTodos.length; index++)
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
                              child: Text(
                                completedTodos[index].toString(),
                                style: TextStyle(fontSize: 16),
                              )),
                          Wrap(
                            spacing: 8,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    deleteCompletedEntry(index);
                                  },
                                  child: Icon(Icons.delete)),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       uncompleteTodo(completedTodos[index]);
                              //       deleteCompletedEntry(index);
                              //     },
                              //     child: Icon(Icons.unarchive))
                            ],
                          ),
                        ],
                      ),
                  ],
                ))
              ],
            )),
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
