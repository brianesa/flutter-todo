import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/todo_bloc.dart';
import 'package:todo/blocs/todo_event.dart';
import 'package:todo/blocs/todo_state.dart';
import 'package:todo/models/todos_model.dart';
import 'package:todo/views/detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  Todos _data;
  TodoBloc _todoBloc;
  @override
  void initState() {
    super.initState();
    _todoBloc = context.read<TodoBloc>()..add(TodoFetchEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _todoBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        builder: (BuildContext context, state) {
          switch (state.runtimeType) {
            case TodoLoadingState:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case TodoFetchState:
              return ListView.builder(
                itemCount: state.todos.data.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (val) {},
                    confirmDismiss: (val) async {
                      final bool res = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                Text('Are you sure want to delete this task?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('OK'),
                              )
                            ],
                          );
                        },
                      );
                      print(res);
                      if (res) {
                        _todoBloc.add(
                          TodoDeleteEvent(
                            id: _data.data[index].sId,
                          ),
                        );
                      }
                      return res;
                    },
                    key: UniqueKey(),
                    child: Card(
                      elevation: 5,
                      child: Material(
                        child: InkWell(
                          onTap: () async {
                            final push = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (BuildContext context) => TodoBloc(),
                                  child: DetailPage(
                                    description: _data.data[index].description,
                                    id: _data.data[index].sId,
                                    completed:
                                        _data.data[index]?.completed ?? false,
                                  ),
                                ),
                              ),
                            );
                            if (push ?? false) {
                              _todoBloc.add(TodoFetchEvent());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${index + 1}. ${_data.data[index].description}',
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                      _data.data[index]?.completed ?? false
                                          ? 'DONE'
                                          : 'IN PROGRESS'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
              break;
            default:
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text('null'),
                  );
                },
              );
          }
        },
        listener: (BuildContext context, state) {
          if (state is TodoErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Something went wrong, please try again later'),
              ),
            );
          } else if (state is TodoFetchState) {
            setState(() {
              _data = state.todos;
              _controller?.clear();
            });
          } else if (state is TodoDeleteState) {
            _todoBloc.add(
              TodoFetchEvent(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10.0))),
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _controller,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "What needs to be done?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          height: 50.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text('Add'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
          if (res) {
            _todoBloc.add(
              TodoAddEvent(
                description: _controller.text,
              ),
            );
            _todoBloc.add(TodoFetchEvent());
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
