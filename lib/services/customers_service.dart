import 'package:basic_utils/basic_utils.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/services/base_service.dart';

class CustomersService extends BaseService<Customer> {

  List<Customer> findByName({required String name, required String location}) {
    return dataBox.values
        .where((customer) => customer.names.contains(name) && StringUtils.isNullOrEmpty(location) ? true : customer.location == location)
        .toList();
  }
}