//{
//         "email": "loic.jumel@utc.fr",
//         "id": 13971,
//         "name": "Loic JUMEL (jumelloi)"
//     }
class User {
  late final String? email;
  late final int id;
  late final String _name;

  User.fromJson(dynamic data) {
    email = data['email'];
    id = data['id'];
    _name = data['name'];
  }
  String get name {
    String name = _name.substring(0, _name.indexOf('(') - 1);
    if (name.length < 2) {
      return subName;
    }
    return name;
  }

  String get subName =>
      _name.substring(_name.indexOf('(') + 1, _name.indexOf(')'));
  String get maj {
    int nameIdx = name.lastIndexOf(" ") + 1;
    String lastNameLetter = "";
    try {
      if (name == subName) throw "user without name";
      lastNameLetter = name.substring(nameIdx, nameIdx + 1);
      String firstNameLetter = name.substring(0, 1);
      return "$firstNameLetter$lastNameLetter".toUpperCase();
    } catch (err) {
      return subName.substring(0, 2).toUpperCase();
    }
  }

  toJson() => {
        "email": email,
        "id": id,
        "name": _name,
      };
}
