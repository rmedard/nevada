import 'package:flutter/material.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class CustomerPage extends StatelessWidget {

  final Customer customer;

  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: customer.names,
        actions: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Nevada.back)),
        body: Center(child: Text('Page for customer: ${customer.names}')));
  }
}
