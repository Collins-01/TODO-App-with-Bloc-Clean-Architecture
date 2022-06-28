import 'package:bloc_clean_architecture/UIs/stats/bloc/stats_bloc.dart';
import 'package:bloc_clean_architecture/UIs/stats/bloc/stats_events.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: Text("Completed " + state.completedTodos.toString()),
            trailing: Text(
              '${state.completedTodos}',
              style: textTheme.headline5,
            ),
          ),
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: Text("Active " + state.activeTodos.toString()),
            trailing: Text(
              '${state.activeTodos}',
              style: textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
