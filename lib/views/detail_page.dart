import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/blocs/todo_bloc.dart';
import 'package:todo/blocs/todo_event.dart';
import 'package:todo/blocs/todo_state.dart';

class DetailPage extends StatefulWidget {
  final String description;
  final bool completed;
  final String id;

  const DetailPage(
      {Key key, this.description, this.id, this.completed})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isDone;
  TextEditingController _controller;
  TodoBloc _todoBloc;
  @override
  void initState() {
    super.initState();
    _isDone = widget.completed;
    _controller = TextEditingController(text: widget.description);
    _todoBloc = context.read<TodoBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO Detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _isDone,
                        onChanged: (val) {
                          setState(() {
                            _isDone = val;
                          });
                        }),
                    Text('Done')
                  ],
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: BlocConsumer<TodoBloc, TodoState>(
                    listener: (context, state) {
                      if (state is TodoFetchState) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        child: state is TodoLoadingState
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : Text('Update'),
                        onPressed: () {
                          _todoBloc.add(
                            TodoUpdateEvent(
                                id: widget.id,
                                description: _controller.text,
                                completed: _isDone),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
