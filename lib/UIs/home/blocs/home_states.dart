import 'package:equatable/equatable.dart';

enum HomeTab { todos, stats }

class HomeState extends Equatable {
  final HomeTab tab;
  const HomeState({this.tab = HomeTab.todos});
  @override
  List<Object?> get props => [tab];
}