// mock_database.dart
import 'dart:async';

class MockDatabase {
  final List<String> _toDoList = [];
  final List<bool> _doneList = [];

  Future<List<String>> loadToDoList() async {
    // Simulate a network/database delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _toDoList;
  }

  Future<List<bool>> loadDoneList() async {
    // Simulate a network/database delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _doneList;
  }

  Future<void> saveToDoList(List<String> todos) async {
    _toDoList.clear();
    _toDoList.addAll(todos);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
  }

  Future<void> saveDoneList(List<bool> dones) async {
    _doneList.clear();
    _doneList.addAll(dones);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
  }
}
