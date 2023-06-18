import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/ui/forms/employee_edit_form.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeeDetailsBlock extends StatefulWidget {

  final Employee employee;

  const EmployeeDetailsBlock({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeDetailsBlock> createState() => _EmployeeDetailsBlockState();
}

class _EmployeeDetailsBlockState extends State<EmployeeDetailsBlock> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
            CircleAvatar(radius: 30, backgroundColor: Colors.grey[400], child: const Icon(Nevada.user, size: 40)),
            const SizedBox(height: 20),
            Text(widget.employee.names, style: textTheme.headlineSmall),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              widget.employee.labelBadge,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('|', style: TextStyle(color: colorScheme.primaryContainer),),
              ),
              Text(widget.employee.contractType.label, style: TextStyle(color: widget.employee.contractType.labelColor),)
            ]),
            const SizedBox(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrer en service', style: textTheme.titleMedium),
                    Text(DateTools.formatter.format(widget.employee.entryDate))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Salaire de base', style: textTheme.titleMedium),
                    Text('${widget.employee.baseSalary} MT/mois')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Congés restants (${DateTime.now().year})', style: textTheme.titleMedium),
                    Text('${widget.employee.holidaysLeft} jours')
                  ],
                )
              ],
            )
          ]
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: EmployeeEditForm(employee: widget.employee, isNew: false)
                  );
                }).then((value) => setState(() {}));
              },
              icon: Icon(Nevada.pencil, color: colorScheme.primary, size: 20))
        ],
      ),
    );
  }
}
