import 'package:contact_list/network/contacts_list_interceptor.dart';
import 'package:dio/dio.dart';

class CustomDio {
  final _dio = Dio();

  CustomDio() {
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes/";
    _dio.interceptors.add(ContactsListInterceptor());
  }

  Dio get dio => _dio;
}
