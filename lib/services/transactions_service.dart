import 'package:basic_utils/basic_utils.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/deliveries_service.dart';

class TransactionsService extends BaseService<Transaction> {

  String getCustomerName(Transaction transaction) {
    if (transaction.type == TransactionType.expense) {
      return 'Nevada';
    } else if (StringUtils.isNotNullOrEmpty(transaction.deliveryUuid)) {
      return DeliveriesService().findById(transaction.deliveryUuid!)?.customer.names ?? 'Inconnu';
    } else {
      return 'Inconnu';
    }
  }
}