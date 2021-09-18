import 'package:todo/models/todo_model.dart';
import 'package:todo/models/todos_model.dart';

abstract class TodoState {
  final TodoModel todoData;
  final Todos todos;

  TodoState({this.todoData, this.todos});
}

class TodoInitialState extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoErrorState extends TodoState {}

class TodoFetchState extends TodoState {
  final Todos todos;

  TodoFetchState({this.todos}) : super(todos: todos);
}

class TodoDeleteState extends TodoState {}
