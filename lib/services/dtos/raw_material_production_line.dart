class RawMaterialProductionLine {
  DateTime date;
  double bottleSize;
  int releasedQuantity = 0;
  int defectQuantity = 0;
  int producedQuantity = 0;

  RawMaterialProductionLine({required this.date, required this.bottleSize});
}