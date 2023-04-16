class RawMaterialRow {
  DateTime date;
  double bottleSize;
  int releasedQuantity;
  int defectQuantity;

  RawMaterialRow(
      {required this.date, required this.bottleSize, required this.releasedQuantity, required this.defectQuantity});
}