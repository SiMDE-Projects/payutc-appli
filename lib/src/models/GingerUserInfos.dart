/// badge_uid : "04303EAAC96F80"
/// is_adulte : true
/// is_cotisant : true
/// last_access : "2022-09-15 10:59:54"
/// login : "jumeltom"
/// mail : "tom.jumel@etu.utc.fr"
/// nom : "JUMEL"
/// prenom : "Tom"
/// type : "etu"

class GingerUserInfos {
  GingerUserInfos({
      this.badgeUid, 
      this.isAdulte, 
      this.isCotisant, 
      this.lastAccess, 
      this.login, 
      this.mail, 
      this.nom, 
      this.prenom, 
      this.type,});

  GingerUserInfos.fromJson(dynamic json) {
    badgeUid = json['badge_uid'];
    isAdulte = json['is_adulte'];
    isCotisant = json['is_cotisant'];
    lastAccess = json['last_access'];
    login = json['login'];
    mail = json['mail'];
    nom = json['nom'];
    prenom = json['prenom'];
    type = json['type'];
  }
  String? badgeUid;
  bool? isAdulte;
  bool? isCotisant;
  String? lastAccess;
  String? login;
  String? mail;
  String? nom;
  String? prenom;
  String? type;
GingerUserInfos copyWith({  String? badgeUid,
  bool? isAdulte,
  bool? isCotisant,
  String? lastAccess,
  String? login,
  String? mail,
  String? nom,
  String? prenom,
  String? type,
}) => GingerUserInfos(  badgeUid: badgeUid ?? this.badgeUid,
  isAdulte: isAdulte ?? this.isAdulte,
  isCotisant: isCotisant ?? this.isCotisant,
  lastAccess: lastAccess ?? this.lastAccess,
  login: login ?? this.login,
  mail: mail ?? this.mail,
  nom: nom ?? this.nom,
  prenom: prenom ?? this.prenom,
  type: type ?? this.type,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['badge_uid'] = badgeUid;
    map['is_adulte'] = isAdulte;
    map['is_cotisant'] = isCotisant;
    map['last_access'] = lastAccess;
    map['login'] = login;
    map['mail'] = mail;
    map['nom'] = nom;
    map['prenom'] = prenom;
    map['type'] = type;
    return map;
  }

}