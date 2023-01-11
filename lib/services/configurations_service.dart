import 'package:hive/hive.dart';
import 'package:nevada/utils/constants.dart';

class ConfigurationsService {

  late Box configBox;

  ConfigurationsService() {
    configBox = Hive.box(configBoxName);
  }

  List<String> getRegions() {
    return configBox.get(ConfigKey.regions.name, defaultValue: []) as List<String>;
  }
}