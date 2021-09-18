import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:todo/blocs/todo_event.dart';
import 'package:todo/blocs/todo_state.dart';
import 'package:todo/models/todos_model.dart';
import 'package:todo/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepository _repository = TodoRepository();
  TodoBloc() : super(TodoInitialState());

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    switch (event.runtimeType) {
      case TodoAddEvent:
        yield* _mapTodoEventToState(event);
        break;
      case TodoFetchEvent:
        yield* _mapTodoFetchEventToState(event);
        break;
      case TodoUpdateEvent:
        yield* _mapTodoUpdateEventToState(event);
        break;
      case TodoDeleteEvent:
        yield* _mapTodoDeleteEventToState(event);
        break;
    }
  }

  Stream<TodoState> _mapTodoEventToState(
    TodoAddEvent event,
  ) async* {
    yield TodoLoadingState();
    try {
      await _repository.createTodo(
        description: event.description,
      );
      yield TodoFetchState();
    } catch (e) {
      yield TodoErrorState();
    }
  }

  Stream<TodoState> _mapTodoUpdateEventToState(
    TodoUpdateEvent event,
  ) async* {
    yield TodoLoadingState();
    try {
      await _repository.updateTodo(
          id: event.id,
          description: event.description,
          completed: event.completed);
      yield TodoFetchState();
    } catch (e) {
      yield TodoErrorState();
    }
  }

  Stream<TodoState> _mapTodoDeleteEventToState(
    TodoDeleteEvent event,
  ) async* {
    yield TodoLoadingState();
    try {
      await _repository.deleteTodo(
        id: event.id,
      );
      yield TodoDeleteState();
    } catch (e) {
      yield TodoErrorState();
    }
  }

  Stream<TodoState> _mapTodoFetchEventToState(
    TodoFetchEvent event,
  ) async* {
    yield TodoLoadingState();
    try {
      Todos data = await _repository.getTodos();
      yield TodoFetchState(todos: data);
    } catch (e) {
      yield TodoErrorState();
    }
  }
}
