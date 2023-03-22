import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class CustomerEditForm extends StatelessWidget {
  final Customer customer;
  final ValueChanged<Customer> editCustomer;

  const CustomerEditForm(
      {Key? key, required this.editCustomer, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var namesController = TextEditingController(text: customer.names);
    var phoneController = TextEditingController(text: customer.phone);
    namesController.addListener(() => customer.names = namesController.value.text);
    phoneController.addListener(() => customer.phone = phoneController.value.text);

    var regions = ConfigurationsService().getRegions(hasAllOption: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: FormBuilder(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: FormBuilderTextField(
                name: 'customer_names',
                controller: namesController,
                decoration: const InputDecoration(
                    label: Text('Noms'),
                    prefixIcon: Icon(Nevada.user_fill)),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                child: FormBuilderTextField(
                  name: 'customer_phone',
                  controller: phoneController,
                  decoration: const InputDecoration(
                      label: Text('Téléphone'),
                      prefixIcon: Icon(Nevada.phone_call)
                  ),)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: FormBuilderDropdown(
                  name: 'customer_region',
                  initialValue: StringUtils.isNullOrEmpty(customer.location) ? regions.entries.first.key : customer.location,
                  decoration: const InputDecoration(
                      label: Text('Quartier'),
                      prefixIcon: Icon(Nevada.location)
                  ),
                  items: regions.entries.mapIndexed<DropdownMenuItem>((index, element) => DropdownMenuItem(
                    value: element.key,
                    child: Row(
                      children: [
                        Text('${++index}.'),
                        const SizedBox(width: 10),
                        Text(element.value)
                      ],
                    ),
                  )).toList(),
                  onChanged: (value) => customer.location = value),
            ),
          ],
        ),
      ),
    );
  }
}
