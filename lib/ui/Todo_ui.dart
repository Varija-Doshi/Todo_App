import 'package:flutter/material.dart';
import 'package:Todo_App/database/database_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoUi extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<TodoUi> {
  final dbhelper = Databasehelper.instance;

  final _controllerTask = TextEditingController();
  final _controllerDesc = TextEditingController();
  bool toogle = true;
  bool check_edit = false;
  String errorText = "";
  String newTask, editedtask, newDescription, editedDescription = "";
  int editId;
  var allTasks = List();
  var alldesc = List();
  List<Widget> children = new List<Widget>();

  void addTodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: newTask,
      Databasehelper.columnDescription: newDescription
    };
    final id = await dbhelper.insert(row);
    print("Add todo id: {$id}");
    Navigator.pop(context);
    newTask = "";
    newDescription = "";
    setState(() {
      toogle = true;
      errorText = "";
    });
  }

  void update(int updateId) async {
    Map<String, dynamic> row = {
      Databasehelper.columnID: updateId,
      Databasehelper.columnName: editedtask,
      Databasehelper.columnDescription: editedDescription
    };
    if (editedtask == "") editedtask = _controllerTask.text;
    if (editedDescription == "") editedDescription = _controllerDesc.text;
    dbhelper.update(row['id'], editedtask, editedDescription);
    Navigator.pop(context);
    editedtask = "";
    editedDescription = "";
    setState(() {
      check_edit = false;
    });
  }

  Future<bool> query() async {
    allTasks = [];
    alldesc = [];
    children = [];
    var allRows = await dbhelper.queryall();
    allRows.forEach((row) {
      allTasks.add(row['task'].toString());
      alldesc.add(row['description'].toString());
      //alldesc.add(row.toString());
      children.add(Card(
        color: Colors.black,
        shadowColor: Colors.yellow,
        elevation: 15.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Slidable(
          // was Container prev.
          //padding: EdgeInsets.all(10.0),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                dbhelper.deletedata(row['id']);
                setState(() {});
              },
            ),
            IconSlideAction(
              caption: 'Edit',
              color: Colors.white,
              foregroundColor: Colors.blue,
              icon: Icons.edit,
              onTap: () {
                check_edit = true;
                _controllerTask.text = row['task'];
                _controllerDesc.text = row['description'];
                newTask = row['task'];
                newDescription = row['description'];
                editId = row['id'];
                print(" update id : {$row['id']}");
                showAlertDialog();
              },
            ),
          ],
          child: ListTile(
            title: Text(
              row['task'],
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 24.0,
                color: Colors.purple,
              ),
            ),
            subtitle: Text(
              row['description'],
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 18.0,
              ),
            ),
            //isThreeLine: true ,
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showAlertDialog() {
    if (!check_edit) {
      _controllerTask.text = "";
      _controllerDesc.text = "";
    }

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
                      if (!check_edit)
                        newTask = value;
                      else
                        editedtask = value;
                    },
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      errorText: toogle ? null : errorText,
                      hintText: 'title',
                    ),
                  ),
                  TextField(
                    controller: _controllerDesc,
                    autofocus: true,
                    onChanged: (value) {
                      if (!check_edit)
                        newDescription = value;
                      else
                        editedDescription = value;
                    },
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'descrption',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
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
                          } else if (!check_edit) {
                            addTodo();
                          } else
                            update(editId);
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
                  ' On Your List... ',
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
                child: Text(
                  "Whats on your day ?? ",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Raleway",
                      fontStyle: FontStyle.italic,
                      color: Colors.lightGreen),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'On Your List.....',
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
                leading: CircleAvatar(
                  radius: 5.0,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    "assets/logo.png",
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
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

/*Slidable(
                    child : null,
                    actionExtentRatio: 0.25,
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: (){},
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: (){},
                      ),
                    ],
                    ),*/
