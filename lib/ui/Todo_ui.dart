import 'package:flutter/material.dart';
import 'package:Todo_App/database/database_helper.dart';

class TodoUi extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<TodoUi> {
  final dbhelper = Databasehelper.instance;

  final _controllerTask = TextEditingController();
  bool toogle = true;
  String errorText = "";
  String newTask = "";
  var allTasks = List();
  List<Widget> children = new List<Widget>();

  void addTodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: newTask,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    newTask = "";
    setState(() {
      toogle = true;
      errorText = "";
    });
  }

  Future<bool> query() async {
    allTasks = [];
    children = [];
    var allRows = await dbhelper.queryall();
    allRows.forEach((row) {
      allTasks.add(row.toString());
      children.add(Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          //padding: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              row['task'],
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 22.0,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red ),
                  onTap:  () {
                      dbhelper.deletedata(row['id']);
                      setState(() {});
                          },
                  ),
              ],
            ),
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showAlertDialog() {
    _controllerTask.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _controllerTask,
                    autofocus: true,
                    onChanged: (value) {
                      newTask = value;
                    },
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      errorText: toogle ? null : errorText,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.purple,
                        onPressed: () {
                          if (_controllerTask.text.isEmpty) {
                            setState(() {
                              errorText = "Cant be empty";
                              toogle = false;
                            });
                          } else if (_controllerTask.text.length > 512) {
                            setState(() {
                              errorText = "Too long!!";
                              toogle = false;
                            });
                          } else {
                            addTodo();
                          }
                        },
                        child: Text(
                          "Done!",
                          style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

/*  Widget card(String task) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Container(
        padding: EdgeInsets.all(2.0),
        child: ListTile(
          title: Text(
            "$task",
            style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 22.0,
            ),
          ),
          onLongPress: () {
            print("Should get deleted");
          },
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text(
              "No data",
            ),
          );
        } else {
          if (allTasks.length == 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Tasks',
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: showAlertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              body: Center(
                child: Text("No Task available"),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Tasks',
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: showAlertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}

/*Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAlertDialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
      ),
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(
            fontFamily: "Raleway",
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            card("first todo"),
          ],
        ),
      ),
    );*/
