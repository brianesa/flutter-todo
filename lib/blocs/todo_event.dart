import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';

abstract class TodoEvent {}

class TodoAddEvent extends TodoEvent {
  final String description;

  TodoAddEvent({@required this.description});
}

class TodoFetchEvent extends TodoEvent {}

class TodoUpdateEvent extends TodoEvent {
  final String id;
  final String description;
  final bool completed;

  TodoUpdateEvent({
    this.id,
    this.description,
    this.completed,
  });
}

class TodoDeleteEvent extends TodoEvent {
  final String id;

  TodoDeleteEvent({
    this.id,
  });
}
