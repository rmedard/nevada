import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/dtos/customer_search_dto.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:uuid/uuid.dart';

class CustomersService extends BaseService<Customer> {

  List<Customer> getAllSorted() {
    return dataBox.values.sortedBy((customer) => customer.names).toList();
  }

  List<Customer> find({required CustomerSearchDto customerSearchDto}) {
    var location = customerSearchDto.region == 'all' ? '' : customerSearchDto.region;
    return dataBox.values
        .where((customer) => customer.names.toLowerCase().contains(customerSearchDto.name.toLowerCase()))
        .where((customer) => StringUtils.isNotNullOrEmpty(location) ? customer.location == location : true)
        .sortedBy((customer) => customer.names)
        .toList();
  }

  Future<bool> createPayment(Customer customer, int amount) {
    customer.balance += amount;
    return customer.save().then((value) {
      var transaction = Transaction(
          uuid: const Uuid().v4(),
          amount: amount,
          type: TransactionType.income,
          deliveryUuid: '',
          status: TransactionStatus.paid,
          createdAt: DateTime.now(),
          senderUuid: customer.uuid);
      return TransactionsService().createNew(transaction.uuid, transaction);
    });
  }
}