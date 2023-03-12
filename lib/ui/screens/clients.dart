import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/model/dtos/snackbar_message.dart';
import 'package:nevada/services/customers_service.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/components/customers_list.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/ui/forms/customer_edit_form.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/ui/utils/ui_utils.dart';

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
                builder: (dialogContext) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Text('Client', style: Theme.of(dialogContext).textTheme.headlineLarge),
                      content: CustomerEditForm(
                          customer: newCustomer,
                          editCustomer: (Customer customer) => newCustomer = customer),
                      actions: [
                        DefaultButton(label: 'Sauvegarder', onSubmit: () => CustomersService().createNew(newCustomer.uuid, newCustomer).then((isCreated) {
                          const String title = 'Création d\'un nouveau client';
                          String message;
                          MessageType messageType;
                          if (isCreated) {
                            message = 'Nouveau client créé avec succès';
                            messageType =  MessageType.success;
                            setState(() => clients = CustomersService().find(customerSearchDto: customerSearchDto));
                          } else {
                            message = 'Création du client échouée';
                            messageType = MessageType.error;
                          }
                          UiUtils().showSnackBar(dialogContext, SnackbarMessage(messageType: messageType, title: title, message: message));
                        }))
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: MetricCard(
                        horizontalPadding: 40,
                        verticalPadding: 20,
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
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: MetricCard(
                        horizontalPadding: 20, verticalPadding: 20,
                        body: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
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
                                      label: const Text('Noms'),
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: hasSearchText ? IconButton(
                                          icon:  const Icon(Icons.clear),
                                          splashColor: Colors.redAccent, splashRadius: 20,
                                          onPressed: () => searchNameController.clear()) : const SizedBox.shrink()
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
