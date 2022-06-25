import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:flutter/material.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
