class Contacts {
  List<Contact>? results;

  Contacts({this.results});

  Contacts.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Contact>[];
      json['results'].forEach((v) {
        results!.add(Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contact {
  String? objectId;
  String? name;
  String? lastName;
  String? email;
  String? position;
  String? imagePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  Contact(
      {this.objectId,
      this.name,
      this.lastName,
      this.email,
      this.position,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  Contact.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['name'];
    lastName = json['last_name'];
    email = json['email'];
    position = json['position'];
    imagePath = json['image_path'];
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['name'] = name;
    data['last_name'] = lastName;
    data['email'] = email;
    data['position'] = position;
    data['image_path'] = imagePath;
    return data;
  }
}
