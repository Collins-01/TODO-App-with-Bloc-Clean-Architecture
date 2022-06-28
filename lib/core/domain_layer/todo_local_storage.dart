import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_clean_architecture/core/data_layer/todos_api.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageTodosApi extends TodosApi {
  LocalStorageTodosApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }
  final SharedPreferences _plugin;
  static const kTodosCollectionKey = '__todos_collection_key__';
  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);
  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);
  void _init() {
    final todosJson = _getValue(kTodosCollectionKey);
    print("todosJson: $todosJson");
    if (todosJson != null) {
      final todos = List<Map>.from(json.decode(todosJson) as List)
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Future<int> clearCompleted() async {
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((element) => element.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodosCollectionKey, jsonEncode(todos));
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount =
        todos.where((e) => e.isCompleted != isCompleted).length;
    final newTodos = [for (var todo in todos) todo.copyWith(isCompleted: true)];
    _todoStreamController.add(newTodos);
    await _setValue(kTodosCollectionKey, json.encode(newTodos));
    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((e) => e.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(kTodosCollectionKey, jsonEncode(todos));
    }
  }

  @override
  Stream<List<Todo>> getTodos() {
    return _todoStreamController.asBroadcastStream();
  }

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((element) => element.id == todo.id);
    if (todoIndex < 0) {
      todos.add(todo);
    } else {
      todos[todoIndex] = todo;
    }

    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, jsonEncode(todos));
  }
}
