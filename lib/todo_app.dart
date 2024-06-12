import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todolist/data/database_repository.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  final DatabaseRepository _databaseRepository =
      DatabaseRepository(); // Repository-Instanz
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
    try {
      _toDoList = await _databaseRepository.getToDoList();
      _doneList = await _databaseRepository.getDoneList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Laden der Daten: $e'),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateToDoList() async {
    await _databaseRepository.updateToDoList(_toDoList);
    await _databaseRepository.updateDoneList(_doneList);
  }

  void _addToDo() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _toDoList.add(_textEditingController.text);
        _doneList.add(false);
        _textEditingController.clear();
      });
      _updateToDoList();
    }
  }

  void _deleteToDo(int index) {
    setState(() {
      _toDoList.removeAt(index);
      _doneList.removeAt(index);
    });
    _updateToDoList();
  }

  void _toggleDone(int index) {
    setState(() {
      _doneList[index] = !_doneList[index];
    });
    _updateToDoList();
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
              children: <Widget>[
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
                          children: [
                            Checkbox(
                              value: _doneList[index],
                              onChanged: (bool? value) {
                                _toggleDone(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteToDo(index),
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
