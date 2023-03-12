import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/dtos/transaction_search_dto.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/ui/forms/inputs/filter_chip_button.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/utils/date_tools.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  final TextEditingController dateRangeTextController = TextEditingController();
  late TransactionSearchDto transactionSearchDto;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    var oldestTransactionDate = TransactionsService().oldestTransactionDate();
    var pastOneMonth = DateTime.now().subtract(const Duration(days: 30));
    var startDate = oldestTransactionDate.isBefore(pastOneMonth) ? pastOneMonth : oldestTransactionDate;
    transactionSearchDto = TransactionSearchDto.init(startDate);
    dateRangeTextController.text = '${DateTools.basicDateFormatter.format(transactionSearchDto.start)} - ${DateTools.basicDateFormatter.format(transactionSearchDto.end)}';
    transactions = TransactionsService().search(transactionSearchDto: transactionSearchDto);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Transactions',
        actions: Row(
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.trending_down),
              label: const Text('Nouvelle Dépense'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.error,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(width: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.trending_up),
              label: const Text('Nouvelle Entrée'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
        body: Column(
          children: [
            MetricCard(
              horizontalPadding: 20,
              verticalPadding: 20,
              body: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('Periode'),
                              prefixIcon: Icon(Icons.calendar_month)),
                          readOnly: true,
                          controller: dateRangeTextController,
                          onTap: () {
                            showDateRangePicker(
                                context: context,
                                firstDate: TransactionsService().oldestTransactionDate().subtract(const Duration(days: 1)),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                                saveText: 'Sauvegarder',
                                builder: (context, builder) {
                                  var screenSize = MediaQuery.of(context).size;
                                  return Container(
                                      color: Colors.transparent,
                                      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: screenSize.width * 0.3),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: builder));
                                }
                            ).then((value) {
                              if (value != null) {
                                transactionSearchDto.start = DateTools.toStartOfDay(value.start);
                                transactionSearchDto.end = DateTools.toEndOfDay(value.end);
                                setState(() {
                                  transactions = TransactionsService()
                                      .search(transactionSearchDto: transactionSearchDto)
                                      .toList();
                                });
                              } else {
                                debugPrint('No value selected');
                              }
                            }, onError: (e) {
                              debugPrint('Error occurred: $e');
                            });
                          }),)),
                    const Separator(direction: SeparatorDirection.vertical),
                    Expanded(flex: 2, child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type de transaction',
                              style: textTheme
                                  .labelMedium?.copyWith(color: textTheme
                                  .labelMedium?.color?.withOpacity(0.8))),
                            Row(
                              children: [
                                FilterChipButton(
                                  label: TransactionType.income.label,
                                  isSelected: transactionSearchDto.types.contains(TransactionType.income),
                                  onChipSelected: (bool selected) {
                                    if (selected) {
                                      transactionSearchDto.types.add(TransactionType.income);
                                    } else {
                                      transactionSearchDto.types.remove(TransactionType.income);
                                    }
                                    setState(() {
                                      transactions = TransactionsService()
                                          .search(transactionSearchDto: transactionSearchDto)
                                          .toList();
                                    });
                                  }),
                                const SizedBox(width: 2),
                                FilterChipButton(
                                    label: TransactionType.expense.label,
                                    isSelected: transactionSearchDto.types.contains(TransactionType.expense),
                                    onChipSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          transactionSearchDto.types.add(TransactionType.expense);
                                        } else {
                                          transactionSearchDto.types.remove(TransactionType.expense);
                                        }
                                        transactions = TransactionsService()
                                            .search(transactionSearchDto: transactionSearchDto)
                                            .toList();
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                        const Separator(direction: SeparatorDirection.vertical),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Statut de transaction',
                                style: textTheme
                                    .labelMedium?.copyWith(color: textTheme
                                    .labelMedium?.color?.withOpacity(0.8))),
                            Row(
                              children: [
                                FilterChipButton(
                                    label: TransactionStatus.paid.label,
                                    isSelected: transactionSearchDto.statuses.contains(TransactionStatus.paid),
                                    onChipSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          transactionSearchDto.statuses.add(TransactionStatus.paid);
                                        } else {
                                          transactionSearchDto.statuses.remove(TransactionStatus.paid);
                                        }
                                        transactions = TransactionsService()
                                            .search(transactionSearchDto: transactionSearchDto)
                                            .toList();
                                      });
                                    }),
                                const SizedBox(width: 2),
                                FilterChipButton(
                                    label: TransactionStatus.pending.label,
                                    isSelected: transactionSearchDto.statuses.contains(TransactionStatus.pending),
                                    onChipSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          transactionSearchDto.statuses.add(TransactionStatus.pending);
                                        } else {
                                          transactionSearchDto.statuses.remove(TransactionStatus.pending);
                                        }
                                        transactions = TransactionsService()
                                            .search(transactionSearchDto: transactionSearchDto)
                                            .toList();
                                      });
                                    })
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Date de paiement')),
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Statut')),
                  ],
                  rows: transactions
                      .mapIndexed<DataRow>((index, transaction) =>
                          DataRow(color: transaction.rowColor, cells: [
                            DataCell(Text('${++index}')),
                            DataCell(Text(DateFormat('dd-MM-yyyy').format(transaction.createdAt))),
                            DataCell(Text(DateFormat('dd-MM-yyyy').format(transaction.dueDate ?? transaction.createdAt))),
                            DataCell(Text(TransactionsService().getCustomerName(transaction))),
                            DataCell(Text(
                              '${transaction.amount} MT',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(transaction.type.icon),
                            DataCell(transaction.status.labelWidget)
                          ]))
                      .toList()),
            ),
          ],
        ));
  }
}
