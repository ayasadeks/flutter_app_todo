
import 'package:flutter/foundation.dart';

class Task with ChangeNotifier{
  final String title;
  final String description;
  final String id;

  Task({
    @required this.id,
    @required this.title,
    @required this.description
  });
}