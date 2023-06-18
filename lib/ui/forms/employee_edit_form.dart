import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/ui/utils/thousand_separator_input_formatter.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeeEditForm extends StatefulWidget {

  final Employee employee;
  final bool isNew;

  const EmployeeEditForm({Key? key, required this.employee, required this.isNew}) : super(key: key);

  @override
  State<EmployeeEditForm> createState() => _EmployeeEditFormState();
}

class _EmployeeEditFormState extends State<EmployeeEditForm> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var namesController = TextEditingController(text: widget.employee.names);
    var salaryController = TextEditingController(text: '${widget.employee.baseSalary}');
    var entryDateController = TextEditingController(text: DateTools.formatter.format(widget.employee.entryDate));
    var dateOfBirthController = TextEditingController(text: DateTools.formatter.format(widget.employee.dateOfBirth));
    var placeOfBirthController = TextEditingController(text: widget.employee.placeOfBirth);

    namesController.addListener(() => widget.employee.names = namesController.value.text);
    salaryController.addListener(() {
      String currentValue = salaryController.value.text.replaceAll(ThousandSeparatorInputFormatter.separator, '');
      widget.employee.baseSalary = int.tryParse(currentValue) ?? 0;
    });
    entryDateController.addListener(() => widget.employee.entryDate = DateTools.formatter.parse(entryDateController.value.text));

    final productFormKey = GlobalKey<FormState>();

    return Form(
      key: productFormKey,
        child: SizedBox(
          width: 600,
          child: MetricCard(
              horizontalPadding: 20,
              verticalPadding: 20,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.isNew ? 'Enregistrer un employé' : 'Modifier les données d\'un employé', style: textTheme.headlineSmall)),
                  const SizedBox(height: 20),
                BasicContainer(
                  child: TextFormField(
                    controller: namesController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Nevada.user),
                        label: Text('Noms')),
                    validator: (value) {
                      if (StringUtils.isNullOrEmpty(value)) {
                        return 'Vous devez saisir un nom';
                      } return null;
                  },),
                ),
                const SizedBox(height: 10),
                  BasicContainer(
                    child: TextFormField(
                      controller: dateOfBirthController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          label: Text('Date de naissance')),
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: widget.employee.entryDate,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTools.formatter.parse('01/01/1950'),
                            lastDate: DateTime.now().add(const Duration(days: 30))
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            dateOfBirthController.text = DateTools.formatter.format(selectedDate);
                          }
                        });
                      },),
                  ),
                  const SizedBox(height: 10),
                  BasicContainer(
                    child: TextFormField(
                      controller: placeOfBirthController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Nevada.location),
                          label: Text('Lieu de naissance'))),
                  ),
                const SizedBox(height: 10),
                  BasicContainer(
                    child: TextFormField(
                      controller: entryDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          label: Text('Date d\'entrée en service')),
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: widget.employee.entryDate,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTools.formatter.parse('01/01/2000'),
                            lastDate: DateTime.now().add(const Duration(days: 30))
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            entryDateController.text = DateTools.formatter.format(selectedDate);
                          }
                        });
                      },),
                  ),
                  const SizedBox(height: 10),
                BasicContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Fonction"),
                        SizedBox(
                          width: double.maxFinite,
                          child: SegmentedButton<JobTitle>(
                            multiSelectionEnabled: false,
                              emptySelectionAllowed: false,
                              segments: [
                                ButtonSegment<JobTitle>(value: JobTitle.machinist, label: Text(JobTitle.machinist.label)),
                                ButtonSegment<JobTitle>(value: JobTitle.assistant, label: Text(JobTitle.assistant.label)),
                                ButtonSegment<JobTitle>(value: JobTitle.seller, label: Text(JobTitle.seller.label)),
                                ButtonSegment<JobTitle>(value: JobTitle.guard, label: Text(JobTitle.guard.label)),
                              ],
                              selected: {
                                widget.employee.jobTitle
                              },
                              onSelectionChanged: (selected) => setState(() => widget.employee.jobTitle = selected.first)),
                        ),
                      ],
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                  BasicContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Type de contrat"),
                          SizedBox(
                            width: double.maxFinite,
                            child: SegmentedButton<ContractType>(
                                multiSelectionEnabled: false,
                                emptySelectionAllowed: false,
                                segments: [
                                  ButtonSegment<ContractType>(value: ContractType.contractor, label: Text(ContractType.contractor.label)),
                                  ButtonSegment<ContractType>(value: ContractType.permanent, label: Text(ContractType.permanent.label)),
                                ],
                                selected: {
                                  widget.employee.contractType
                                },
                                onSelectionChanged: (selected) => setState(() => widget.employee.contractType = selected.first)),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                BasicContainer(
                  child: TextFormField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      ThousandSeparatorInputFormatter()
                    ],
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Nevada.coins),
                        label: Text('Salaire mensuel'),
                        suffix: Text('MT/mois')),),
                ),
                const SizedBox(height: 30),
                FilledButton(
                    onPressed: () {
                      if (productFormKey.currentState!.validate()) {
                        if (widget.isNew) {
                          EmployeesService().createNew(widget.employee.uuid, widget.employee);
                        } else {
                          widget.employee.save();
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Sauvegarder'))
              ],)),));
  }
}
