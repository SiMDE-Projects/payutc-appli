class User {
  late final String? email;
  late final int id;
  late final String _name;

  User.fromJson(dynamic data) {
    email = data['email'];
    id = data['id'];
    _name = data['name'];
  }

  String get firstName {
    return _name
        .split(' ')
        .firstWhere((name) => !name.toUpperCase().contains(name));
  }

  String get lastName {
    return _name
        .split(' ')
        .skipWhile((name) => !name.toUpperCase().contains(name))
        .takeWhile((name) => name.toUpperCase() == name)
        .join(' ');
  }

  String get userName =>
      _name.substring(_name.indexOf('(') + 1, _name.indexOf(')'));

  toJson() => {
        "email": email,
        "id": id,
        "name": _name,
      };
}
