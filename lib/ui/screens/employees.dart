import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/forms/employee_edit_form.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/screens/entities/employee_page.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:nevada/utils/num_utils.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> with SingleTickerProviderStateMixin {

  late AnimationController _detailsPanelController;

  List<Employee> employees = [];
  double detailsPanelSize = 0;
  double detailsPanelSizeMax = 500;
  bool isExpanded = false;
  Employee? expandedEmployee;

  List<DataColumn> getColumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('#')),
      const DataColumn(label: Text('Noms')),
      const DataColumn(label: Text('Date d\'entrée en service')),
      const DataColumn(label: Text('Salaire de base')),
      DataColumn(label: Text('Congés restant (${DateTime.now().year})')),
      const DataColumn(label: Text('')),
    ];

    if (isExpanded) {
      columns.removeRange(2, 5);
    }
    return columns;
  }

  List<DataRow> getRows() {
    var rows = EmployeesService().getAll().mapIndexed<DataRow>((index, employee) {
      return DataRow(
        selected: expandedEmployee != null && employee.uuid == expandedEmployee?.uuid,
          color: MaterialStatePropertyAll<Color>(expandedEmployee != null && employee.uuid == expandedEmployee?.uuid ? Colors.red : Colors.white),
          cells: [
        DataCell(Text('${++index}')),
        DataCell(Text(employee.names)),
        DataCell(Text(DateTools.formatter.format(employee.entryDate))),
        DataCell(Text('${employee.baseSalary} MT/mois')),
        DataCell(Text('${employee.holidaysLeft}')),
        DataCell(Row(
          children: [
            Visibility(
              visible: !isExpanded,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: EmployeeEditForm(employee: employee, isNew: false));
                            }).then((value) => setState(() {}));
                      },
                      tooltip: 'Modifier',
                      icon: const Icon(Nevada.pencil, size: 18),
                      splashRadius: 20),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Supprimer un employé'),
                                content: Text('Êtes-vous sûr de vouloir supprimer l\'empoloyé: ${employee.names}'),
                                actions: [
                                  FilledButton.tonal(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Annuller')),
                                  FilledButton(
                                      onPressed: (){},
                                      child: const Text('Confirmer'))
                                ],
                              );
                            });
                      },
                      tooltip: 'Supprimer',
                      icon: const Icon(Icons.delete_outline, size: 18),
                      splashRadius: 20),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (isExpanded) {
                      if (expandedEmployee?.uuid == employee.uuid) {
                        detailsPanelSize = 0;
                        isExpanded = false;
                      }
                    } else {
                      detailsPanelSize = detailsPanelSizeMax;
                      isExpanded = true;
                    }
                    expandedEmployee = employee;
                  });
                },
                icon: const Icon(Nevada.forward, size: 18))
          ],
        ))
      ]);
    }).toList();

    if (isExpanded) {
      for (var row in rows) {
        row.cells.removeRange(2, 5);
      }
    }
    return rows;
  }

  @override
  void initState() {
    super.initState();
    _detailsPanelController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300));
    _detailsPanelController.addListener(() {
      isExpanded = _detailsPanelController.isAnimating || _detailsPanelController.isCompleted;
    });
    employees = EmployeesService().getAll();
  }

  @override
  void dispose() {
    _detailsPanelController.dispose();
    super.dispose();
  }

  void onEmployeeLineTap(Employee employee) {
    if (isExpanded) {
      if (expandedEmployee?.uuid == employee.uuid) {
        _detailsPanelController.reverse()
            .then((value) => setState(() => expandedEmployee = null));
      } else {
        setState(() => expandedEmployee = employee);
      }
    } else {
      _detailsPanelController.forward();
      setState(() => expandedEmployee = employee);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Personnel',
        actions: FilledButton.icon(
            icon: const Icon(Icons.person_add_alt_sharp),
            label: const Text('Nouvel employé'),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            onPressed: (){
              showDialog(context: context, builder: (context) {
                return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: EmployeeEditForm(employee: Employee.empty(), isNew: true)
                );
              }).then((value) => setState(() => employees = EmployeesService().getAll()));
            }),
        body: Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              var employee = employees[index];
                              bool isSelected = expandedEmployee != null && expandedEmployee?.uuid == employee.uuid;
                              return Card(
                                color: isSelected ? colorScheme.surface : colorScheme.background,
                                elevation: 0,
                                child: ListTile(
                                  selected: isSelected,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text('${index + 1}. ${employee.names}')),
                                      Expanded(
                                        flex: 1,
                                        child: UnconstrainedBox(
                                          child: employee.labelBadge,
                                        ),
                                      ),
                                      Expanded(
                                          flex: isExpanded ? 0 : 1,
                                          child: Visibility(
                                              visible: !isExpanded,
                                              child: Text(employee.contractType.label))),
                                      Expanded(
                                          flex: isExpanded ? 0 : 1,
                                          child: Visibility(
                                              visible: !isExpanded,
                                              child: Text('${employee.baseSalary.asMoney} MT/mois'))),
                                      Expanded(
                                          flex: isExpanded ? 0 : 1,
                                          child: Visibility(
                                              visible: !isExpanded,
                                              child: Text('${employee.holidaysLeft}'))),
                                      IconButton(
                                          onPressed: () => onEmployeeLineTap(employee),
                                          icon: const Icon(Nevada.forward))
                                    ],
                                  ),
                                  tileColor: Colors.white,
                                  style: ListTileStyle.list,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  onTap: () => onEmployeeLineTap(employee),
                                ),
                              );
    }),
                      ),
                      SizeTransition(
                        sizeFactor: _detailsPanelController,
                        axis: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: 500,
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: colorScheme.primary.withOpacity(0.2))),
                          ),
                          child: isExpanded ? EmployeePage(employee: expandedEmployee!, onPageClosed: () {
                            _detailsPanelController.reverse()
                                .then((value) => setState(() => expandedEmployee = null));
                          },) : const SizedBox.shrink(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
