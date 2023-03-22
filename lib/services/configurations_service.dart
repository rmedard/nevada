import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:nevada/utils/constants.dart';

class ConfigurationsService {

  late Box configBox;

  ConfigurationsService() {
    configBox = Hive.box(configBoxName);
  }

  Map<String, String> getRegions({required bool hasAllOption}) {
    Map<dynamic, dynamic> rawRegions = configBox.get(ConfigKey.regions.name, defaultValue: <dynamic, dynamic>{});
    Map<String, String> regions = {};
    if (hasAllOption) {
      regions.putIfAbsent('all', () => 'Tout');
    }
    regions.addAll(Map.fromEntries(rawRegions
        .map((key, value) => MapEntry<String, String>(key.toString(), value.toString()))
        .entries
        .sortedBy((element) => element.value)
        .map((element) => MapEntry<String, String>(element.key, element.value)).toList()));

    return regions;
  }

  String getRegion(String key) {
    var regions = getRegions(hasAllOption: false);
    return regions.containsKey(key) ? regions.entries.firstWhere((element) => element.key == key).value : '';
  }
}