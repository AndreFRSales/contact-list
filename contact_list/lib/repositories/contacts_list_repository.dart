import 'package:contact_list/models/contacts.dart';
import 'package:contact_list/network/custom_dio.dart';
import 'package:dio/dio.dart';

class ContactsListRepository {
  final _customDio = CustomDio();

  Future<List<Contact>> fetchContacts() async {
    var response = await _customDio.dio.get("/Contact");
    if (_isResponseSuccess(response)) {
      var result = response.data['results'];
      return (result as List).map((e) => Contact.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  save(Contact contact) async {
    try {
      await _customDio.dio.post("/Contact", data: contact.toJson());
    } catch (e) {
      e.toString();
    }
  }

  update(Contact contact) async {
    try {
      await _customDio.dio
          .put("/Contact/${contact.objectId}", data: contact.toJson());
    } catch (e) {
      e.toString();
    }
  }

  bool _isResponseSuccess(Response response) {
    return (response.statusCode ?? 0) >= 200 &&
        (response.statusCode ?? 0) <= 299;
  }
}
