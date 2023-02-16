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
    final particles = ["de", "du", "des", "d'"];
    final lastName = _name
        .split(' ')
        .skipWhile((name) => !name.toUpperCase().contains(name))
        .takeWhile((name) => name.toUpperCase() == name)
        .join(' ');
    final words = lastName.split(' ');
    return words
        .map((word) => particles.contains(word.toLowerCase())
            ? word.toLowerCase()
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
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

  String get firstNameInitial {
    return _name[0];
  }

  String get lastNameInitial {
    if (lastName.isEmpty) {
      return "*";
    }
    final particles = [
      "d'",
      "de",
      "von",
      "von der",
      "zu",
      "del",
      "de las",
      "de les",
      "de los",
      "las",
      "os",
      "da",
      "das",
      "dos",
      "af",
      "av"
    ];
    String lowerCaseLastName = lastName.toLowerCase();
    particles.sort((a, b) => b.length.compareTo(a.length));
    for (String particle in particles) {
      if (lowerCaseLastName.startsWith("$particle ")) {
        return lowerCaseLastName[particle.length + 1].toUpperCase();
      } else if (lowerCaseLastName == particle) {
        return "*";
      }
    }
    return lowerCaseLastName[0].toUpperCase();
  }

  String get initials {
    return "$firstNameInitial$lastNameInitial";
  }

  toJson() => {
        "email": email,
        "id": id,
        "name": _name,
      };
}
