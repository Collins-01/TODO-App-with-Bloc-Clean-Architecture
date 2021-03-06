import 'dart:developer';

import 'package:bloc_clean_architecture/UIs/home/home_view.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';
import 'package:bloc_clean_architecture/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final TodosRepository todosRepository;
  const App({Key? key, required this.todosRepository}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todosRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO BLoC Demo',
      theme: FlutterTodosTheme.light,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const HomeView(),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
