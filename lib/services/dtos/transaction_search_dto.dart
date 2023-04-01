import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/dtos/delivery_search_dto.dart';

class TransactionSearchDto extends DeliverySearchDto {
  List<TransactionType> types = <TransactionType>[];
  List<TransactionStatus> statuses = <TransactionStatus>[];

  TransactionSearchDto._();

  static TransactionSearchDto init(DateTime startDate) {
    TransactionSearchDto searchDto = TransactionSearchDto._();
    searchDto.start = startDate;
    return searchDto;
  }
}