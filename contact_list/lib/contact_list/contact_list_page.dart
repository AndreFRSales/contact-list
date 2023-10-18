import 'dart:io';

import 'package:contact_list/common/date/format_date.dart';
import 'package:contact_list/contact_detail/contact_detail_page.dart';
import 'package:contact_list/models/contacts.dart';
import 'package:contact_list/repositories/contacts_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final contactsRepository = ContactsListRepository();
  var formatDate = FormatDate();
  var contacts = <Contact>[];
  var loading = false;
  @override
  void initState() {
    fetchContacts();
    super.initState();
  }

  fetchContacts() async {
    setState(() {
      loading = true;
    });
    contacts = await contactsRepository.fetchContacts();
    loading = false;
    setState(() {});
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, Contact? contact) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactDetailPage(contact: contact)),
    );
    if (!mounted) return;

    contacts = [];
    await fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
      ),
      body: loading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (_, index) {
                  var contact = contacts[index];
                  return InkWell(
                    onTap: () {
                      _navigateAndDisplaySelection(context, contact);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: (contact.imagePath != null &&
                                  contact.imagePath?.trim().isEmpty == true)
                              ? const FaIcon(FontAwesomeIcons.addressBook)
                              : Image.file(File(contact.imagePath!)),
                          title: Text(contact.name ?? ""),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact.lastName ?? ""),
                              Text("Cargo: ${contact.position}")
                            ],
                          ),
                          trailing: Text(
                              "Atualizado em: ${formatDate.format(contact.updatedAt)}"),
                        ),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndDisplaySelection(context, null);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    ));
  }
}
