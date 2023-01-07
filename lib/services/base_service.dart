import 'package:hive/hive.dart';

class BaseService<T> {
  late Box<T> dataBox;

  BaseService() {
    dataBox = Hive.box(T.toString());
  }

  List<T> getAll() {
    return dataBox.values.toList();
  }

}