import 'package:flutter/material.dart';
import 'package:flutter_app/providers/task.dart';
import 'package:flutter_app/providers/tasks.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskController = TextEditingController();
  DateTime _taskDate = DateTime.now();
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();

  var _editedTask = Task(
    id: null,
    title: '',
    description: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final taskId = ModalRoute.of(context).settings.arguments as String;
      if (taskId != null) {
        _editedTask =
            Provider.of<Tasks>(context, listen: false).findById(taskId);
        _initValues = {
          'title': _editedTask.title,
          'description': _editedTask.description,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }


  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedTask.id != null) {
      await Provider.of<Tasks>(context, listen: false)
          .updateTask(_editedTask.id, _editedTask);
    } else {
      try {
        await Provider.of<Tasks>(context, listen: false).addTask(_editedTask);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: Text(
            "New Task",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Form(
                      key: _form,
                      child: Column(children: <Widget>[
                        TextFormField(
                            initialValue: _initValues['title'],
                            decoration: InputDecoration(labelText: "title"),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedTask = Task(
                                title: value,
                                description: _editedTask.description,
                                id: _editedTask.id,
                              );
                            }),
                        SizedBox(height: 5,),
                        TextFormField(
                            initialValue: _initValues['description'],
                            maxLines: 4,
                            focusNode: _descriptionFocusNode,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: "What are you planning?"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a description.';
                              }
                              if (value.length < 10) {
                                return 'Should be at least 10 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedTask = Task(
                                title: _editedTask.title,
                                description: value,
                                id: _editedTask.id,
                              );
                            }),
                      ]),
                    ),
                    Container(padding: EdgeInsets.only(bottom: 5),
                        height: 55,
                        width: double.infinity,
                        child: RaisedButton(
                          color:  Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Create",
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            onPressed: _saveForm))
                  ],
                ),
            ));
  }
}
//if (_taskController.text.isNotEmpty) {
//_editedTask = Task(
//title: _taskController.text, date: _taskDate);
//Navigator.pop(context, _editedTask);
//}
