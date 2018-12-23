import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: "Lista de Tarefas",
    home: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Home(),
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  final todoFieldController = TextEditingController();

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: todoFieldController,
                    onSubmitted: (value) => _addTask(),
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text("add"),
                  onPressed: _addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem)),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveFile() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    file.writeAsString(data);
    return file;
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) return 1;
        if (!a["ok"] && b["ok"]) return -1;
        return 0;
      });

      _saveFile();
    });

    return null;
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white)),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveFile();
          });
        },
      ),
      onDismissed: (direction) => _removeTask(direction, index, context),
    );
  }

  void _addTask() {
    Map<String, dynamic> newTodo = Map();
    newTodo["title"] = todoFieldController.text;
    newTodo["ok"] = false;
    todoFieldController.text = "";
    setState(() {
      _toDoList.add(newTodo);
      _saveFile();
    });
  }

  void _removeTask(direction, int index, BuildContext context) {
    setState(() {
      _lastRemoved = Map.from(_toDoList[index]);
      _lastRemovedPos = index;
      _toDoList.removeAt(index);
      _saveFile();
    });

    final snack = SnackBar(
      content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          setState(() {
            _toDoList.insert(_lastRemovedPos, _lastRemoved);
            _saveFile();
          });
        },
      ),
      duration: Duration(seconds: 2),
    );

    Scaffold.of(context).showSnackBar(snack);
  }
}
