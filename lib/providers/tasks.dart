import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './task.dart';

class Tasks with ChangeNotifier {
  List<Task> _items = [
//    Task(
//       id: 'p1',
//       title: 'Red Shirt',
//       description: 'A red shirt - it is pretty red!',
//     ),
  ];
  final String authToken;
  final String userId;

  Tasks(this.authToken, this.userId, this._items);

  List<Task> get items {
    return [..._items];
  }

  Task findById(String id) {
    return _items.firstWhere((task) => task.id == id);
  }

  Future<void> fetchAndSetTasks([bool filterByUser = false]) async {
    var url =
        'https://todoflutter-422e4.firebaseio.com/tasks.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Task> loadedTasks = [];
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(Task(
          id: taskId,
          title: taskData['title'],
          description: taskData['description'],
        ));
      });
      _items = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTask(Task task) async {
    final url =
        'https://todoflutter-422e4.firebaseio.com/tasks.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'creatorId': userId,
        }),
      );
      final newTask = Task(
        title: task.title,
        description: task.description,
        id: json.decode(response.body)['name'],
      );
      _items.add(newTask);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTask(String id, Task newTask) async {
    final taskIndex = _items.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final url =
          'https://todoflutter-422e4.firebaseio.com/tasks/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newTask.title,
            'description': newTask.description,
          }));
      _items[taskIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteTask(String id) async {
    final url =
        'https://todoflutter-422e4.firebaseio.com/tasks/$id.json?auth=$authToken';
    final existingTaskIndex = _items.indexWhere((task) => task.id == id);
    var existingTask = _items[existingTaskIndex];
    _items.removeAt(existingTaskIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingTaskIndex, existingTask);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingTask = null;
  }
}
