import 'package:flutter/material.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/services/dtos/delivery_panel.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class CustomerPage extends StatefulWidget {

  final Customer customer;

  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {

  List<DeliveryPanel> deliveryPanels = [];

  @override
  void initState() {
    super.initState();
    deliveryPanels = DeliveriesService()
        .customerDeliveries(widget.customer)
        .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Nevada.back)),
                      const SizedBox(width: 30),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.customer.names, style: textTheme.displayMedium),
                          Text(ConfigurationsService().getRegion(widget.customer.location), style: textTheme.titleLarge)
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Text('Crédit', style: textTheme.displaySmall),
                    Text('${widget.customer.balance}', style: textTheme.titleLarge?.copyWith(color: colorScheme.error))
                  ],)
                ]),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    elevation: 0, dividerColor: colorScheme.primary.withOpacity(0.2),
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) =>
                        setState(() => deliveryPanels[index].isExpanded = !isExpanded),
                    children: deliveryPanels.map((delivery) => delivery.toPanel()).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
