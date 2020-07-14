import 'package:flutter/material.dart';
import 'package:flutter_app/providers/tasks.dart';
import 'package:flutter_app/widgets/app_drawer.dart';
import 'package:flutter_app/widgets/todo_item.dart';
import 'package:provider/provider.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {

  static const routeName = '/user-tasks';

  Future<void> _refreshTasks(BuildContext context) async {
    await Provider.of<Tasks>(context, listen: false)
        .fetchAndSetTasks(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.routeName);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Your Tasks"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 10, top: 20, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: FutureBuilder(
          future: _refreshTasks(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshTasks(context),
                      child: Consumer<Tasks>(
                        builder: (ctx, tasksData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: tasksData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                ToDoItem(
                                    tasksData.items[i].id,
                                    tasksData.items[i].title,
                                    tasksData.items[i].description,
                                   // tasksData.items[i].date
                                   ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

//        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//            Widget>[
//          Padding(
//              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
//              child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      padding: EdgeInsets.all(10),
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        shape: BoxShape.circle,
//                      ),
//                      child: Icon(
//                        Icons.event_note,
//                        color: Colors.blue,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text("All", style: Theme.of(context).textTheme.headline),
//                    Text("22 Tasks",
//                        style: TextStyle(
//                            fontSize: 18,
//                            fontWeight: FontWeight.bold,
//                            color: Colors.white54)),
//                    Container(
//                      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.only(
//                              topLeft: Radius.circular(30),
//                              topRight: Radius.circular(30))),
//                      child: ListView.builder(
//                        padding: const EdgeInsets.all(10.0),
//                        itemCount: _todoList.length,
//                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//                          // builder: (c) => products[i],
//                          value: tasksData[i],
//                          child: ToDoItem(
//                              // products[i].id,
//                              // products[i].title,
//                              // products[i].imageUrl,
//                              ),
//                        ),
//                      ),
//                    )
//              ]))
//  ]));
// }
//}

//      ],
//    ),)
//    ,
//    ]
//    ,
//    )
//    ,
//    );
//  }

//Expanded(
//child: Container(
//padding: EdgeInsets.only(left: 20, top: 20, right: 20),
//decoration: BoxDecoration(
//color: Colors.white,
//borderRadius: BorderRadius.only(
//topLeft: Radius.circular(30),
//topRight: Radius.circular(30))),
//child: ListView.builder(
//itemCount: _todoList.length,
//itemBuilder: (context, index) {
//return ToDoItem();
//}),
//),
//)

//
//FutureBuilder(
//future: _refreshTasks(context),
//builder: (ctx, snapshot) =>
//snapshot.connectionState == ConnectionState.waiting
//? Center(
//child: CircularProgressIndicator(),
//)
//: RefreshIndicator(
//onRefresh: () => _refreshTasks(context),
//child: Consumer<Tasks>(
//builder: (ctx, tasksData, _) => Padding(
//padding: EdgeInsets.all(8),
//child: ListView.builder(
//itemCount: tasksData.items.length,
//itemBuilder: (_, i) => Column(
//children: [
//ToDoItem(
////                                                tasksData.items[i].id,
////                                                tasksData.items[i].title,
////                                                tasksData.items[i].description,
//),
//Divider(),
//],
//),
//),
//),
//),
//),
//),
