import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeeEditForm extends StatelessWidget {

  final Employee employee;
  final bool isNew;

  const EmployeeEditForm({Key? key, required this.employee, required this.isNew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    var namesController = TextEditingController(text: employee.names);
    var salaryController = TextEditingController(text: '${employee.baseSalary}');
    var entryDateController = TextEditingController(text: DateTools.formatter.format(employee.entryDate));

    namesController.addListener(() => employee.names = namesController.value.text);
    salaryController.addListener(() => employee.baseSalary = int.tryParse(salaryController.value.text) ?? 0);
    entryDateController.addListener(() => employee.entryDate = DateTools.formatter.parse(entryDateController.value.text));

    final productFormKey = GlobalKey<FormState>();

    return Form(
      key: productFormKey,
        child: SizedBox(
          width: 400,
          child: MetricCard(
              horizontalPadding: 20,
              verticalPadding: 20,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(isNew ? 'Enregistrer un employé' : 'Modifier les données d\'un employé', style: textTheme.headlineSmall)),
                  const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: namesController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Nevada.user),
                          label: Text('Noms')),
                      validator: (value) {
                        if (StringUtils.isNullOrEmpty(value)) {
                          return 'Vous devez saisir un nom';
                        } return null;
                    },)),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: entryDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          label: Text('Date d\'entrée en service')),
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: employee.entryDate,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTools.formatter.parse('01/01/2000'),
                            lastDate: DateTime.now().add(const Duration(days: 30))
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            entryDateController.text = DateTools.formatter.format(selectedDate);
                          }
                        });
                    },)),

                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: salaryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                      ],
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Nevada.coins),
                          label: Text('Salaire mensuel'),
                          suffix: Text('MT/mois')),)),
                const SizedBox(height: 30),
                FilledButton(
                    onPressed: () {
                      if (productFormKey.currentState!.validate()) {
                        if (isNew) {
                          EmployeesService().createNew(employee.uuid, employee);
                        } else {
                          employee.save();
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Sauvegarder'))
              ],)),));
  }
}
