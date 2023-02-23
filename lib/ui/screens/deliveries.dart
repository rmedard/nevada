import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/model/dtos/delivery_panel.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

import 'elements/screen_elements.dart';

class Deliveries extends StatefulWidget {
  const Deliveries({Key? key}) : super(key: key);

  @override
  State<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  late List<DeliveryPanel> deliveryPanels = [];

  var searchNameController = TextEditingController();
  var customerSearchDto = CustomerSearchDto();
  var hasSearchText = false;

  @override
  void initState() {
    super.initState();
    deliveryPanels = DeliveriesService()
        .getAll()
        .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
        .toList();
    searchNameController.addListener((){
      hasSearchText = !StringUtils.isNullOrEmpty(searchNameController.value.text);
      setState(() {
        customerSearchDto.name = searchNameController.value.text;
        deliveryPanels = DeliveriesService()
            .find(customerSearchDto: customerSearchDto)
            .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenElements().defaultBodyFrame(
      context: context,
      title: 'Livraisons',
      actions: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Livraison'),
        style: FilledButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MetricCard(
                horizontalPadding: 20,
                verticalPadding: 20,
                body: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FormBuilderTextField(
                          name: 'search_deliveries_customer_names',
                          controller: searchNameController,
                          decoration: InputDecoration(
                              label: const Text('Chercher'),
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: hasSearchText ? IconButton(
                                  icon:  const Icon(Icons.clear),
                                  onPressed: () => searchNameController.clear()) : const SizedBox.shrink()
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                        child: FormBuilderDropdown(
                            name: 'search_deliveries_customer_region',
                            borderRadius: BorderRadius.circular(10),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                label: Text('Quartier'),
                                prefixIcon: Icon(Nevada.location)),
                            initialValue: 'all',
                            items: ConfigurationsService()
                                .getRegions(hasAllOption: true)
                                .entries
                                .mapIndexed<DropdownMenuItem>(
                                  (index, element) => DropdownMenuItem(
                                key: UniqueKey(),
                                value: element.key,
                                child: Row(
                                  children: [
                                    index == 0 ? const SizedBox.shrink() : Text('$index.'),
                                    const SizedBox(width: 10),
                                    Text(element.value)
                                  ],
                                ),
                              ),
                            ).toList(),
                            onChanged: (value) {
                              customerSearchDto.region = value;
                              setState(() {
                                deliveryPanels = DeliveriesService()
                                    .find(customerSearchDto: customerSearchDto)
                                    .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
                                    .toList();
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FormBuilderDateRangePicker(
                          name: 'search_deliveries_date_range',
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now()),
                    )
                  ],
            )),
            const SizedBox(height: 20),
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) =>
                  setState(() => deliveryPanels[index].isExpanded = !isExpanded),
              children: deliveryPanels.map((delivery) => delivery.toPanel()).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
