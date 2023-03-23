import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';

class EmployeePage extends StatelessWidget {

  final Employee employee;
  const EmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(child: Text(employee.names),),);
  }
}
