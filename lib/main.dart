import 'package:bloc_clean_architecture/bootstrap.dart';
import 'package:bloc_clean_architecture/core/domain_layer/todo_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );
  bootstrap(todosApi: todosApi);
}
