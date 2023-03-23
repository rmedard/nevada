import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/forms/employee_edit_form.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Personnel',
        actions: FilledButton.icon(
            icon: const Icon(Nevada.user_add, size: 15),
            label: const Text('Nouvel employé'),
            onPressed: (){
              showDialog(context: context, builder: (context) {
                return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: EmployeeEditForm(employee: Employee.empty(), isNew: true)
                );
              }).then((value) => setState(() {}));
            }),
        body: Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: DataTable(
                  columns: [
                    const DataColumn(label: Text('#')),
                    const DataColumn(label: Text('Noms')),
                    const DataColumn(label: Text('Date d\'entrée en service')),
                    const DataColumn(label: Text('Salaire de base')),
                    DataColumn(label: Text('Congés restant (${DateTime.now().year})')),
                    const DataColumn(label: Text('')),
                  ],
                  rows: EmployeesService().getAll().mapIndexed<DataRow>((index, employee) {
                    return DataRow(cells: [
                      DataCell(Text('${++index}')),
                      DataCell(Text(employee.names)),
                      DataCell(Text(DateTools.basicDateFormatter.format(employee.entryDate))),
                      DataCell(Text('${employee.baseSalary} MT/mois')),
                      DataCell(Text('${employee.holidaysLeft}')),
                      DataCell(Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              tooltip: 'Modifier',
                              icon: const Icon(Nevada.pencil, size: 18),
                              splashRadius: 20),
                          const SizedBox(width: 10),
                          IconButton(
                              onPressed: () {},
                              tooltip: 'Supprimer',
                              icon: const Icon(Icons.delete_outline, size: 18),
                              splashRadius: 20),
                          Text('Actions'),
                        ],
                      ))
                    ]);
                  }).toList()),
            ),
          ),
        ));
  }
}
