import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/delivery_payment_status.dart';
import 'package:nevada/ui/components/products_delivery_table.dart';

class CustomerDeliveryForm extends StatelessWidget {
  final Delivery delivery;
  final bool isNew;

  const CustomerDeliveryForm({Key? key, required this.delivery, required this.isNew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = ProductsService().getAll();
    var quantityEditControllers = <String, TextEditingController>{};
    var textTheme = Theme.of(context).textTheme;
    for (var product in products) {
      quantityEditControllers.putIfAbsent(product.uuid, () => TextEditingController(text: '0'));
    }
    return SingleChildScrollView(
      child: Column(children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date de livraison', style: textTheme.headline5),
                Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: textTheme.headline4),
              ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Client', style: textTheme.headline5),
                Text(delivery.customer.names, style: textTheme.headline4)
            ]),
          ],
        ),
        ProductDeliveryTable(delivery: delivery),
        Visibility(
          visible: isNew,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: DeliveryPaymentStatus()),
        )
      ]),
    );
  }
}
