import 'package:bloc_clean_architecture/UIs/home/blocs/home_cubits.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/UIs/home/components/build_home_tab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeViewContents(),
    );
  }
}

class _HomeViewContents extends StatelessWidget {
  const _HomeViewContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: [
          HomeTabButton(
            groupValue: selectedTab,
            value: HomeTab.stats,
            icon: const Icon(Icons.list_rounded),
          ),
          HomeTabButton(
            groupValue: selectedTab,
            value: HomeTab.todos,
            icon: const Icon(Icons.show_chart_rounded),
          ),
        ],
      ),
    );
  }
}
