import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

class BaseService<T extends HiveObject> with UiLoggy {
  late Box<T> dataBox;

  BaseService() {
    dataBox = Hive.box(T.toString());
  }

  List<T> getAll() {
    return dataBox.values.toList();
  }

  Future<bool> delete(String uuid) async {
    loggy.info("Deleting entity: ${T.runtimeType.toString()} | ID: $uuid}");
    return await dataBox.delete(uuid).then((_) {
      loggy.info('Entity $uuid deleted successfully!');
      return true;
    }, onError: (error) {
      loggy.error(error);
      return false;
    });
  }

  Future<bool> createNew(String uuid, T t) async {
    loggy.info("Creating entity: ${t.runtimeType.toString()}");
    return await dataBox.put(uuid, t).then((_) {
      loggy.info('Entity $uuid of type ${t.runtimeType.toString()} created successfully!');
      return true;
    }, onError: (error) {
      loggy.error(error);
      return false;
    });
  }

  Future<bool> update(T t) async {
    loggy.info('Updating entity: ${t.key}');
    return await t.save().then((_) {
      loggy.info('Entity ${t.key} of type ${t.runtimeType.toString()} updated successfully!');
      return true;
    }, onError: (error) {
      loggy.error(error);
      return false;
    });
  }
}
