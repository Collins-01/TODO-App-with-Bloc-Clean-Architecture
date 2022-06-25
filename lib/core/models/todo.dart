import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Todo extends Equatable {
  final String title;
  final String description;
  final String id;
  final bool isCompleted;
  Todo({
    String? id,
    this.description = '',
    this.isCompleted = false,
    required this.title,
  })  : assert(id == null || id.isEmpty,
            "id can not be null and id should not be empty"),
        id = id ?? const Uuid().v4();

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        description: json['description'],
        id: json['id'],
        isCompleted: json['isCompleteds'],
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}
