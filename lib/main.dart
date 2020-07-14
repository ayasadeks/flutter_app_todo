import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/tasks.dart';
import 'package:flutter_app/screens/add_task_screen.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/first_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Tasks>(
            update: (ctx, auth, previousTasks) => Tasks(
              auth.token,
              auth.userId,
              previousTasks == null ? [] : previousTasks.items,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: TextTheme(
                  headline: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white)),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Color(0xfff2f9fe),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[200])),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[200])),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[200])),
              ),
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
              authResultSnapshot.connectionState ==
                  ConnectionState.waiting
                  ? AuthScreen()
                  : FirstScreen(),
            ),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              FirstScreen.routeName: (ctx) => FirstScreen(),
              AddTaskScreen.routeName: (ctx) => AddTaskScreen(),
            },
          ),
        ));
  }
}
