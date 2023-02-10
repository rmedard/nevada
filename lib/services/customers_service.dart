import 'package:basic_utils/basic_utils.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/services/base_service.dart';

class CustomersService extends BaseService<Customer> {

  List<Customer> find({required CustomerSearchDto customerSearchDto}) {
    var location = customerSearchDto.region == 'all' ? '' : customerSearchDto.region;
    return dataBox.values
        .where((customer) => customer.names.toLowerCase().contains(customerSearchDto.name.toLowerCase()))
        .where((customer) => StringUtils.isNotNullOrEmpty(location) ? customer.location == location : true)
        .toList();
  }
}