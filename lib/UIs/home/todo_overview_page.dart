import 'package:bloc_clean_architecture/UIs/home/blocs/home_events.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/UIs/home/components/build_todo_list_tile.dart';
import 'package:bloc_clean_architecture/UIs/home/components/build_todo_overview_filter_button.dart';
import 'package:bloc_clean_architecture/UIs/home/components/build_todo_overview_option_button.dart';
import 'package:bloc_clean_architecture/UIs/home/home_bloc.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoOverViewPage extends StatelessWidget {
  const TodoOverViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// `BlocProvider` wraps the entire widget with the Bloc  that will be used for that page
    /// Just the the ViewModel for that view, so we can have access to the `Bloc or Cubit`
    return BlocProvider(
      create: (context) => TodosHomeBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodoOverViewPage(),
    );
  }
}

class TodoOverviewView extends StatelessWidget {
  const TodoOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODOs"),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),

      ///Bloc Listeners are used to listen and act on recived events.
      body: MultiBlocListener(
        listeners: [
          /// Shows a snackbar, if there is an error
          BlocListener<TodosHomeBloc, TodoOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("An error Occured"),
                    ),
                  );
              }
            },
          ),

          BlocListener<TodosHomeBloc, TodoOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    action: SnackBarAction(
                        label: "",
                        onPressed: () => context
                            .read<TodosHomeBloc>()
                            .add(const TodosOverviewUndoDeletionRequested())),
                    content: Text(
                        "Are you sure you want to delete, ${deletedTodo.title} ? ")));
            },
          ),
        ],

        /// The `Builder` listens and builds the UIs to react to a particular `event or state`
        child: BlocBuilder<TodosHomeBloc, TodoOverviewState>(
            builder: (context, state) {
          if (state.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return CupertinoScrollbar(
            child: ListView(
              children: [
                for (final todo in state.todos)
                  TodoListTile(
                    todo: todo,
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosHomeBloc>().add(
                            TodoOverViewCompletionToggled(
                                isCompleted: isCompleted, todo: todo),
                          );
                    },
                    onDismissed: (_) => context.read<TodosHomeBloc>()
                      ..add(TodoOverviewDeleted(todo: todo)),
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
