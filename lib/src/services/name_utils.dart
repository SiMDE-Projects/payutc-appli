String formatFirstName(String firstName) {
  return firstName.isNotEmpty
      ? '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}'
      : '';
}

String formatLastName(String lastName) {
  final particles = ["de", "du", "des", "d'"];
  final words = lastName.split(' ');
  return words
      .map((word) => particles.contains(word.toLowerCase())
          ? word.toLowerCase()
          : (word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : ''))
      .join(' ');
}

String formatUserName(String userName) {
  if (userName.isEmpty) {
    return "@***";
  }
  return (userName[0] == '@' ? '' : '@') + userName.toLowerCase();
}

String firstNameInitial(String firstName) {
  if (firstName.isEmpty) {
    return "*";
  }
  return firstName[0];
}

String lastNameInitial(String lastName) {
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

String initials(String firstName, String lastName) {
  return "${firstNameInitial(firstName)}${lastNameInitial(lastName)}";
}
