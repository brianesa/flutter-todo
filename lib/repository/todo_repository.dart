import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/models/todos_model.dart';
import 'package:todo/networking/api_provider.dart';

class TodoRepository {
  ApiProvider _provider = ApiProvider();

  Future<TodoModel> createTodo({@required String description}) async {
    final data = jsonEncode({
      'description': description,
    });
    final response = await _provider.post('/task', data);
    return TodoModel.fromJson(response);
  }

  Future<Todos> getTodos() async {
    final response = await _provider.get('/task');
    print(response);
    return Todos.fromJson(response);
  }

  Future<TodoModel> updateTodo(
      {@required String id, String description, bool completed}) async {
    final data =
        jsonEncode({'description': description, 'completed': completed});
    final response = await _provider.put('/task/$id', data);
    return TodoModel.fromJson(response);
  }

  Future<TodoModel> deleteTodo({@required String id}) async {
    final response = await _provider.delete('/task/$id');
    print(response);
    return TodoModel.fromJson(response);
  }
}
