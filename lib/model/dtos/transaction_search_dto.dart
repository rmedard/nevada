import 'package:nevada/model/dtos/delivery_search_dto.dart';
import 'package:nevada/model/transaction.dart';

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