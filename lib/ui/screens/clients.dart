import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/services/customers_service.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/components/customers_list.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/ui/forms/customer_edit_form.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {

  var searchNameController = TextEditingController();
  var customerSearchDto = CustomerSearchDto();


  var hasSearchText = false;
  var clients = CustomersService().getAll();

  @override
  void initState() {
    super.initState();
    searchNameController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    searchNameController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    hasSearchText = !StringUtils.isNullOrEmpty(searchNameController.value.text);
    setState(() {
      customerSearchDto.name = searchNameController.value.text;
      clients = CustomersService().find(customerSearchDto: customerSearchDto);
    });
  }

  @override
  Widget build(BuildContext context) {
    var newCustomer = Customer.empty();
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Clients',
        actions: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Client'),
          style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Text('Client', style: Theme.of(context).textTheme.headlineLarge),
                      content: CustomerEditForm(
                          customer: Customer.empty(),
                          editCustomer: (Customer customer) => newCustomer = customer),
                      actions: [
                        DefaultButton(label: 'Sauvegarder', onSubmit: () => CustomersService().createNew(newCustomer.uuid, newCustomer))
                      ],
                      actionsPadding: const EdgeInsets.all(20));
                });
          },
        ),
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      children: [
                        MetricCard(
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 350,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FormBuilderTextField(
                                  name: 'search_names',
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
                              const SizedBox(height: 10),
                              Container(
                                width: 350,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: FormBuilderDropdown(
                                    name: 'search_customer_region',
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
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      customerSearchDto.region = value;
                                      setState(() {
                                        clients = CustomersService().find(customerSearchDto: customerSearchDto);
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        MetricCard(
                          body: Row(
                            children: [
                              Icon(Icons.people_alt, color: Theme.of(context).primaryColor),
                              const Separator(direction: SeparatorDirection.vertical),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Clients'),
                                  Text(
                                    clients.length.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: CustomersList(customers: clients),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
