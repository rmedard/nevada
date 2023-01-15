import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/transaction.dart';

class DeliveryPaymentStatus extends StatefulWidget {

  const DeliveryPaymentStatus({Key? key}) : super(key: key);

  @override
  State<DeliveryPaymentStatus> createState() => _DeliveryPaymentStatusState();
}

class _DeliveryPaymentStatusState extends State<DeliveryPaymentStatus> {

  TransactionStatus? deliveryPaymentStatus = TransactionStatus.pending;

  var selectedDate = DateTime.now().add(const Duration(days: 7));
  final _dateController = TextEditingController();

  String selectedDateValue() {
    return DateFormat('EEEE, dd/MM/yyyy').format(selectedDate);
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = selectedDateValue();
  }

  @override
  Widget build(BuildContext context) {
    var debtDelayDays = selectedDate.difference(DateTime.now()).inDays + 1;
    return Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(children: [
            RadioListTile(
                value: TransactionStatus.paid,
                groupValue: deliveryPaymentStatus,
                title: const Text('Livraison payée'),
                onChanged: (value) => setState(() => deliveryPaymentStatus = value)),
            RadioListTile(
                value: TransactionStatus.pending,
                groupValue: deliveryPaymentStatus,
                title: const Text('Livraison à crédit'),
                secondary: Visibility(
                    visible: deliveryPaymentStatus == TransactionStatus.pending,
                    child: SizedBox(
                      width: 360,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('A payer le', style: Theme.of(context).textTheme.headline4),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    initialDatePickerMode: DatePickerMode.day,
                                    firstDate: DateTime.now(),
                                    keyboardType: TextInputType.datetime,
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    lastDate: DateTime.now().add(const Duration(days: 30)));
                                if (picked != null) {
                                  setState(() {
                                    selectedDate = picked;
                                    _dateController.text = selectedDateValue();
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: const Icon(Icons.edit, size: 15),
                                        enabled: false,
                                        suffix: Text('+$debtDelayDays jours')),
                                    keyboardType: TextInputType.text,
                                    controller: _dateController
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                onChanged: (value) => setState(() => deliveryPaymentStatus = value))
          ],),
        ));
  }
}
