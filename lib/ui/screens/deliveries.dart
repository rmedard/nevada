import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/services/dtos/delivery_panel.dart';
import 'package:nevada/services/dtos/delivery_search_dto.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

import 'elements/screen_elements.dart';

class Deliveries extends StatefulWidget {
  const Deliveries({Key? key}) : super(key: key);

  @override
  State<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  late List<DeliveryPanel> deliveryPanels = [];

  var searchNameController = TextEditingController();
  var deliverySearchDto = DeliverySearchDto();
  var hasSearchText = false;

  @override
  void initState() {
    super.initState();

    deliveryPanels = DeliveriesService()
        .search(deliverySearchDto: deliverySearchDto)
        .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
        .toList();

    searchNameController.addListener((){
      hasSearchText = !StringUtils.isNullOrEmpty(searchNameController.value.text);
      setState(() {
        deliverySearchDto.name = searchNameController.value.text;
        deliveryPanels = DeliveriesService()
            .search(deliverySearchDto: deliverySearchDto)
            .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
                body: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: BasicContainer(
                        child: FormBuilderTextField(
                          name: 'search_deliveries_customer_names',
                          controller: searchNameController,
                          decoration: InputDecoration(
                              label: const Text('Noms'),
                              prefixIcon: const Icon(Nevada.user),
                              suffixIcon: hasSearchText ? IconButton(
                                  icon:  const Icon(Icons.clear),
                                  onPressed: () => searchNameController.clear()) : const SizedBox.shrink()
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: BasicContainer(
                        child: FormBuilderDropdown(
                            name: 'search_deliveries_customer_region',
                            borderRadius: BorderRadius.circular(10),
                            decoration: const InputDecoration(
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
                              deliverySearchDto.region = value;
                              setState(() {
                                deliveryPanels = DeliveriesService()
                                    .search(deliverySearchDto: deliverySearchDto)
                                    .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
                                    .toList();
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: BasicContainer(
                        child: FormBuilderDateRangePicker(
                          name: 'search_deliveries_date_range',
                          format: DateTools.formatter,
                          decoration: const InputDecoration(
                              label: Text('Periode'),
                              prefixIcon: Icon(Icons.calendar_month)),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialValue: DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now()),
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                          pickerBuilder: (context, builder) {
                            var screenSize = MediaQuery.of(context).size;
                            return Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: screenSize.width * 0.3),
                                child: ClipRRect(borderRadius: BorderRadius.circular(20), child: builder));
                          },
                          onChanged: (value) {
                            if (value != null) {
                              deliverySearchDto.start = value.start;
                              deliverySearchDto.end = value.end;
                              setState(() {
                                deliveryPanels = DeliveriesService()
                                    .search(deliverySearchDto: deliverySearchDto)
                                    .map((e) => DeliveryPanel(isExpanded: false, delivery: e))
                                    .toList();
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
            )),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
            ),
          ],
        ),
      ),
    );
  }
}
