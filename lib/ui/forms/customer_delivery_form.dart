import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/services/configurations_service.dart';
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
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SizedBox(
          width: 350,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date de livraison', style: textTheme.headlineMedium?.copyWith(color: Colors.grey[500])),
                  Text(DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()), style: textTheme.headlineMedium),
                ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Client', style: textTheme.headlineMedium?.copyWith(color: Colors.grey[500])),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(delivery.customer.names, style: textTheme.headlineMedium),
                      Text(ConfigurationsService().getRegion(delivery.customer.location), style: textTheme.headlineSmall),
                    ],
                  )
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ProductDeliveryTable(delivery: delivery),
        Visibility(visible: isNew,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: DeliveryPaymentStatus()),
        )
      ]),
    );
  }
}
