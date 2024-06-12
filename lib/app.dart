import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Liste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoScreen(),
    );
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _toDoList = [];
  List<bool> _doneList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _loadToDoList() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simuliert Ladezeit
    final prefs = await SharedPreferences.getInstance();
    _toDoList = prefs.getStringList('toDoList') ?? [];
    _doneList = List<bool>.from(
        prefs.getStringList('doneList')?.map((e) => e == 'true') ?? []);
    setState(() => _isLoading = false);
  }

  Future<void> _updateToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('toDoList', _toDoList);
    await prefs.setStringList(
        'doneList', _doneList.map((e) => e.toString()).toList());
  }

  void _addToDo() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _toDoList.add(_textEditingController.text);
        _doneList.add(false);
        _textEditingController.clear();
        _updateToDoList();
      });
    }
  }

  void _editToDo(int index) {
    _textEditingController.text = _toDoList[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit To-Do'),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          onSubmitted: (_) => _updateEditedToDo(index),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _updateEditedToDo(index),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _updateEditedToDo(int index) {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _toDoList[index] = _textEditingController.text;
        _textEditingController.clear();
        _updateToDoList();
        Navigator.of(context).pop();
      });
    }
  }

  void _deleteToDo(int index) {
    setState(() {
      _toDoList.removeAt(index);
      _doneList.removeAt(index);
      _updateToDoList();
    });
  }

  void _toggleDone(int index) {
    setState(() {
      _doneList[index] = !_doneList[index];
      _updateToDoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('To-Do Liste'),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Neues To-Do hinzufügen',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addToDo,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _toDoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_toDoList[index]),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editToDo(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteToDo(index),
                            ),
                            IconButton(
                              icon: Icon(_doneList[index]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              onPressed: () => _toggleDone(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
