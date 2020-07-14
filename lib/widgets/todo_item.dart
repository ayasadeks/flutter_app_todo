import 'package:flutter/material.dart';
import 'package:flutter_app/providers/tasks.dart';
import 'package:flutter_app/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

class ToDoItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  //final String date;

   ToDoItem(this.id, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    //DateFormat('dd-MM hh:mm').format(date)
    return Card(margin: EdgeInsets.all(7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 20,
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddTaskScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Tasks>(context, listen: false)
                        .deleteTask(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
//trailing: Checkbox(
//onChanged: (_) => onChecked(index),
//value: task.status,
//activeColor: Theme.of(context).primaryColor,
//),