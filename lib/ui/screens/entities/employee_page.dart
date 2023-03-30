import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/ui/components/employee_detais_block.dart';
import 'package:nevada/ui/components/employee_holidays_block.dart';
import 'package:nevada/ui/components/employee_salaries_block.dart';

class EmployeePage extends StatelessWidget {

  final Employee employee;
  final Function() onPageClosed;
  const EmployeePage({Key? key, required this.employee, required this.onPageClosed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: onPageClosed,
                    icon: const Icon(Icons.cancel_outlined, size: 20))
              ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                EmployeeDetailsBlock(employee: employee),
                const SizedBox(height: 20),
                EmployeeSalariesBlock(employee: employee),
                const SizedBox(height: 20),
                EmployeeHolidaysBlock(employee: employee),
                const SizedBox(height: 20),
              ]),
          ),
        ],
      ),
    );
  }
}
