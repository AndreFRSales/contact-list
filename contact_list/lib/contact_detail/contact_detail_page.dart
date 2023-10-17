import 'dart:io';

import 'package:contact_list/models/contacts.dart';
import 'package:contact_list/repositories/contacts_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class ContactDetailPage extends StatefulWidget {
  Contact? contact;
  ContactDetailPage({super.key, this.contact});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  final ContactsListRepository _contactsListRepository =
      ContactsListRepository();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var positionController = TextEditingController();

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
        child: Column(
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
                decoration: const InputDecoration(hintText: "Digite seu nome"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: lastNameController,
                onChanged: (value) => {},
                decoration:
                    const InputDecoration(hintText: "Digite seu sobrenome"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: emailController,
                onChanged: (value) => {},
                decoration: const InputDecoration(hintText: "Digite seu email"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: positionController,
                onChanged: (value) => {},
                decoration:
                    const InputDecoration(hintText: "Digite sua ocupação"),
              ),
            ),
            Container(
              width: double.infinity,
              color: const ColorScheme.light().primary,
              margin: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: () {},
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
                photo = await picker.pickImage(source: ImageSource.gallery);
                widget.contact?.imagePath = photo!.path;
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {});
              },
            )
          ]);
        }));
  }
}
