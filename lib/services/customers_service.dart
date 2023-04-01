import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/dtos/customer_search_dto.dart';

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
}