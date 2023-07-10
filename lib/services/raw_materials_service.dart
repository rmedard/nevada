import 'package:collection/collection.dart';
import 'package:nevada/model/raw_material_movement.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/dtos/raw_material_production_line.dart';
import 'package:nevada/services/production_service.dart';
import 'package:nevada/utils/date_tools.dart';

class RawMaterialsService extends BaseService<RawMaterialMovement> {

  @override
  List<RawMaterialMovement> getAll() {
    return dataBox.values
        .sorted((a, b) => b.date.compareTo(a.date))
        .toList();
  }

  List<RawMaterialProductionLine> getRawMaterialProductionLines() {
    Map<int, List<RawMaterialMovement>> rawMaterialMovements = getAll().groupListsBy((raw) => raw.date.toInt);
    var refills = ProductionService().getAllSorted();
    Map<DateTime, RawMaterialProductionLine> productionLines = {};
    for (var groupedMovements in rawMaterialMovements.values) {
      var groupingDate = groupedMovements.first.date;
      var groupListsBy = groupedMovements.groupListsBy((r) => r.unitSize);
      groupListsBy.forEach((key, rawMaterialMovement) {
        RawMaterialProductionLine rawMaterialProductionLine = RawMaterialProductionLine(date: groupingDate, bottleSize: key);
        var defectMovements = rawMaterialMovement
            .where((movement) => movement.movementType == MaterialMovementType.defect);
        var releasedMovements = rawMaterialMovement
            .where((movement) => movement.movementType == MaterialMovementType.released);
        var defects = 0;
        var released = 0;
        if (defectMovements.isNotEmpty) {
          defects = defectMovements
              .map((movement) => movement.quantity)
              .reduce((qty1, qty2) => qty1 + qty2);
        }
        if (releasedMovements.isNotEmpty) {
          released = rawMaterialMovement
              .where((movement) => movement.movementType == MaterialMovementType.released)
              .map((movement) => movement.quantity)
              .reduce((qty1, qty2) => qty1 + qty2);
        }
        rawMaterialProductionLine.defectQuantity = defects;
        rawMaterialProductionLine.releasedQuantity = released;
        refills
            .where((refill) => refill.date.toInt == groupingDate.toInt && refill.product.isStockable && refill.product.unitSize == key)
            .forEach((element) {
              rawMaterialProductionLine.producedQuantity += element.product.unitsInPack;
        });
        productionLines.putIfAbsent(groupingDate, () => rawMaterialProductionLine);
      });
    }
    return productionLines.values.sorted((line1, line2) => line2.date.compareTo(line1.date)).toList();
  }
}