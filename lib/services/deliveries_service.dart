import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_search_dto.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/delivery_lines_service.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:uuid/uuid.dart';

class DeliveriesService extends BaseService<Delivery> {
  bool isValidDelivery(Delivery? delivery) {
    return delivery != null &&
        delivery.lines.isNotEmpty &&
        delivery.lines.none((line) => line.productQuantity < 1);
  }

  List<Delivery> search({required DeliverySearchDto deliverySearchDto}) {
    var location = deliverySearchDto.region == 'all' ? '' : deliverySearchDto.region;
    return dataBox.values
        .where((delivery) => delivery.customer.names.toLowerCase().contains(deliverySearchDto.name.toLowerCase()))
        .where((delivery) => StringUtils.isNotNullOrEmpty(location) ? delivery.customer.location == location : true)
        .where((delivery) => deliverySearchDto.start != null && delivery.date.isAfter(deliverySearchDto.start!))
        .where((delivery) => deliverySearchDto.end != null && delivery.date.isBefore(deliverySearchDto.end!))
        .sorted((deliveryA, deliveryB) => deliveryB.date.compareTo(deliveryA.date))
        .toList();
  }

  Future<void> createNewDelivery(Delivery delivery,
      TransactionStatus transactionStatus, DateTime? paymentDueDate) async {
    bool created = await createNew(delivery.uuid, delivery);
    if (created) {
      /** Reduce stock **/
      for (var deliveryLine in delivery.lines) {
        deliveryLine.product.totalStock -= deliveryLine.productQuantity;
        deliveryLine.product.save();
      }

      /** Create transaction **/
      delivery.customer.lastDeliveryDate = delivery.date;
      int deliveryPrice = computeDeliveryPrice(delivery);
      var transaction = Transaction(
          uuid: const Uuid().v4(),
          amount: deliveryPrice,
          type: TransactionType.income,
          deliveryUuid: delivery.uuid,
          status: transactionStatus,
          createdAt: DateTime.now());
      transaction.dueDate = paymentDueDate;
      bool transactionCreated =
          await TransactionsService().createNew(transaction.uuid, transaction);
      if (transactionCreated) {
        if (transaction.status == TransactionStatus.pending) {
          delivery.customer.balance -= deliveryPrice;
        }
      }
      delivery.customer.save();
    }
  }

  int computeDeliveryPrice(Delivery delivery) {
    return delivery.lines
        .map((line) => line.productUnitPrice * line.productQuantity)
        .reduce((lineOneTotal, lineTwoTotal) => lineOneTotal + lineTwoTotal);
  }

  Future<bool> deleteDelivery(Delivery delivery) {
    for (var deliveryLine in delivery.lines) {
      DeliveryLinesService().delete(deliveryLine.uuid);
    }
    return delete(delivery.uuid);
  }
}
