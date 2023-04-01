import 'package:flutter/material.dart';
import 'package:nevada/model/dtos/delivery_line.dart';

class DeliveryLineEditDto {
  DeliveryLine deliveryLine;
  TextEditingController quantityEditController;
  TextEditingController unitPriceEditController;
  FocusNode editUnitPriceFocusNode;

  DeliveryLineEditDto(
      {
        required this.deliveryLine,
        required this.quantityEditController,
        required this.unitPriceEditController,
        required this.editUnitPriceFocusNode
      });
}
