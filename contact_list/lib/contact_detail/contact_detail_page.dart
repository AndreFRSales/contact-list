import 'dart:io';

import 'package:contact_list/models/contacts.dart';
import 'package:contact_list/repositories/contacts_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ContactDetailPage extends StatefulWidget {
  Contact? contact;
  ContactDetailPage({super.key, this.contact});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var positionController = TextEditingController();
  var contactsListRepository = ContactsListRepository();

  String? nameError;
  String? lastNameError;
  String? positionError;
  String? emailError;

  @override
  void initState() {
    fillContact();
    super.initState();
  }

  fillContact() {
    nameController.text = widget.contact?.name ?? "";
    lastNameController.text = widget.contact?.lastName ?? "";
    emailController.text = widget.contact?.email ?? "";
    positionController.text = widget.contact?.position ?? "";
    if (widget.contact?.imagePath?.isNotEmpty == true) {
      photo = XFile(widget.contact?.imagePath ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.contact == null
              ? "Adicionar contato"
              : "Atualizar contato")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(children: [
          Column(
            children: [
              Container(
                child: photo != null
                    ? InkWell(
                        onTap: () {
                          openPhotosChooser(context);
                        },
                        child: ClipOval(
                            child: Image.file(
                          File(photo!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        )),
                      )
                    : InkWell(
                        child: const FaIcon(FontAwesomeIcons.cameraRetro),
                        onTap: () async {
                          openPhotosChooser(context);
                        },
                      ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                    controller: nameController,
                    onChanged: (value) => {},
                    decoration: InputDecoration(
                      hintText: "Digite seu nome",
                      errorText: nameError,
                    )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: lastNameController,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    hintText: "Digite seu sobrenome",
                    errorText: lastNameError,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: emailController,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    hintText: "Digite seu email",
                    errorText: emailError,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: positionController,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    hintText: "Digite sua ocupação",
                    errorText: positionError,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: const ColorScheme.light().primary,
                margin: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      cleanErrors();
                    });
                    var name = nameController.text;
                    var lastName = lastNameController.text;
                    var email = emailController.text;
                    var position = positionController.text;

                    var isFormValid =
                        _validateFields(name, lastName, position, email);
                    if (!isFormValid) {
                      return;
                    }
                    if (widget.contact?.objectId == null) {
                      var contactToSave = Contact(
                          name: name,
                          lastName: lastName,
                          email: email,
                          position: position,
                          imagePath: photo?.path ?? "");
                      contactsListRepository.save(contactToSave);
                      Navigator.pop(context, true);
                    } else {
                      widget.contact?.name = name;
                      widget.contact?.lastName = lastName;
                      widget.contact?.email = email;
                      widget.contact?.position = position;
                      widget.contact?.imagePath = photo?.path ?? "";
                      if (widget.contact != null) {
                        contactsListRepository.update(widget.contact!);
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: Text(
                    widget.contact == null
                        ? "Adicionar contato"
                        : "Atualizar contato",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  openPhotosChooser(context) async {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Wrap(children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera),
              title: const Text("Câmera"),
              onTap: () async {
                photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  String path =
                      (await path_provider.getApplicationDocumentsDirectory())
                          .path;
                  String photoName = basename(photo!.path);
                  await photo!.saveTo("$path/$photoName");
                  await GallerySaver.saveImage(photo!.path);
                  widget.contact?.imagePath = photo!.path;
                  photo = photo;
                  setState(() {});
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.images),
              title: const Text("Galeria"),
              onTap: () async {
                var photoResult =
                    await picker.pickImage(source: ImageSource.gallery);
                if (photoResult != null) {
                  photo = photoResult;
                  widget.contact?.imagePath = photo!.path;
                }
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {});
              },
            )
          ]);
        }));
  }

  bool _validateFields(
      String name, String lastName, String position, String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    var isValid = true;
    if (name.isEmpty) {
      nameError = "Nome inválido";
      isValid = false;
    }

    if (lastName.isEmpty) {
      lastNameError = "Sobrenome inválido";
      isValid = false;
    }

    if (position.isEmpty) {
      positionError = "Cargo inválido";
      isValid = false;
    }

    var isEmail = emailRegex.hasMatch(email);
    if (!isEmail) {
      emailError = "Email inválido";
      isValid = false;
    }
    setState(() {});
    return isValid;
  }

  cleanErrors() {
    nameError = null;
    lastNameError = null;
    positionError = null;
    emailError = null;
  }
}
