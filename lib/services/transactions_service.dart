import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/services/dtos/transaction_search_dto.dart';

class TransactionsService extends BaseService<Transaction> {

  @override
  List<Transaction> getAll() {
    return dataBox.values
        .sorted((a, b) => b.createdAt.compareTo(a.createdAt))
        .toList();
  }

  List<Transaction> search({required TransactionSearchDto transactionSearchDto}) {
    return dataBox.values
        .where((transaction) => getCustomerName(transaction).toLowerCase().contains(transactionSearchDto.name.toLowerCase()))
        .where((transaction) => transactionSearchDto.start != null && transaction.createdAt.compareTo(transactionSearchDto.start!) >= 0)
        .where((transaction) => transactionSearchDto.end != null && transaction.createdAt.compareTo(transactionSearchDto.end!) <= 0)
        .where((transaction) => transactionSearchDto.types.isEmpty || transactionSearchDto.types.contains(transaction.type))
        .where((transaction) => transactionSearchDto.statuses.isEmpty || transactionSearchDto.statuses.contains(transaction.status))
        .sorted((a, b) => b.createdAt.compareTo(a.createdAt))
        .toList();
  }

  String getCustomerName(Transaction transaction) {
    if (transaction.type == TransactionType.expense) {
      return 'Nevada';
    } else if (StringUtils.isNotNullOrEmpty(transaction.deliveryUuid)) {
      return DeliveriesService().findById(transaction.deliveryUuid!)?.customer.names ?? 'Inconnu';
    } else {
      return 'Inconnu';
    }
  }

  DateTime oldestTransactionDate() {
    return dataBox.values.map((transaction) => transaction.createdAt).minOrNull ?? DateTime.now();
  }
}