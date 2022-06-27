import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/app.dart';
import 'package:bloc_clean_architecture/core/data_layer/todos_api.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';
import 'package:flutter/material.dart';

void bootstrap({required TodosApi todosApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  final todosRepository = TodosRepository(todosApi: todosApi);

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(todosRepository: todosRepository),
        ),
        // blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
