// database_repository.dart
import 'mock_database.dart';

class DatabaseRepository {
  final MockDatabase _database = MockDatabase();

  Future<List<String>> getToDoList() => _database.loadToDoList();
  Future<List<bool>> getDoneList() => _database.loadDoneList();

  Future<void> saveToDoList(List<String> todos) =>
      _database.saveToDoList(todos);
  Future<void> saveDoneList(List<bool> dones) => _database.saveDoneList(dones);

  updateToDoList(List<String> toDoList) {}

  updateDoneList(List<bool> doneList) {}
}
