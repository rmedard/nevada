import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/ui/components/employee_holidays_block.dart';
import 'package:nevada/ui/components/employee_salaries_block.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeePage extends StatelessWidget {

  final Employee employee;
  const EmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined, size: 20)),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Nevada.pencil,
                        color: colorScheme.primary, size: 20))
              ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                CircleAvatar(radius: 30, backgroundColor: Colors.grey[400], child: const Icon(Nevada.user, size: 40)),
                const SizedBox(height: 20),
                Text(employee.names, style: textTheme.headlineSmall),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Entrer en service', style: textTheme.titleMedium),
                        Text(DateTools.basicDateFormatter.format(employee.entryDate))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Salaire de base', style: textTheme.titleMedium),
                        Text('${employee.baseSalary} MT/mois')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Congés restants (${DateTime.now().year})', style: textTheme.titleMedium),
                        Text('${employee.holidaysLeft} jours')
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    EmployeeSalariesBlock(employee: employee),
                    const SizedBox(height: 30),
                    EmployeeHolidaysBlock(employee: employee),
                ]),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
