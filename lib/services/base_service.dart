import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

class BaseService<T> with UiLoggy {
  late Box<T> dataBox;

  BaseService() {
    dataBox = Hive.box(T.toString());
  }

  List<T> getAll() {
    return dataBox.values.toList();
  }

  Future<bool> delete(String uuid) async {
    loggy.info("Deleting entity: ${T.runtimeType.toString()} | ID: $uuid}");
    return await dataBox.delete(uuid).then((value) {
      loggy.info('Entity $uuid deleted successfully!');
      return true;
    }, onError: (error) {
      loggy.error(error);
      return false;
    });
  }

  void createNew(String uuid, T t) {
    loggy.info("Creating entity: ${t.runtimeType.toString()}");
    dataBox.put(uuid, t);
  }
}
