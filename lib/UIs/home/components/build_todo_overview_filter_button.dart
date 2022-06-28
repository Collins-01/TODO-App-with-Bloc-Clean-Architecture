import 'package:bloc_clean_architecture/UIs/home/blocs/home_events.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/UIs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    final activeFilter =
        context.select((TodosHomeBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: "todosOverviewFilterTooltip",
      onSelected: (filter) {
        context.read<TodosHomeBloc>().add(TodosOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text("All"),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text("Active"),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text("Completed"),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
