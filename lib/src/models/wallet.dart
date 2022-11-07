/// auto_enable_mobile_payment : false
/// balances : [{"card_credit":820,"created":"2022-09-01T17:37:12.281686Z","credit":820,"currency":1,"id":46780,"updated":"2022-09-15T08:45:38.830450Z"}]
/// blocked : false
/// closed : null
/// config : 1
/// created : "2022-08-31T07:18:52.335699Z"
/// credit : 820
/// force_adult : true
/// id : 17996
/// is_credit_consistent : true
/// is_mobile_payment_active : false
/// merged_into : null
/// name : "Tom"
/// should_pay_activation_fees : true
/// tag : {"id":21741,"short_tag":null,"tag":"04303EAAC96F80","tag_group":null}
/// updated : "2022-09-15T08:49:39.491573Z"
/// user : {"email":"tom.jumel@etu.utc.fr","first_name":"Tom","id":27930,"last_name":"JUMEL","organisation":"","phone":"","photo_url":"","username":"jumeltom"}

class Wallet {
  Wallet.fromJson(dynamic json) {
    autoEnableMobilePayment = json['auto_enable_mobile_payment'];
    if (json['balances'] != null) {
      json['balances'].forEach((v) {
        balances = Balances.fromJson(v);
      });
    }
    blocked = json['blocked'];
    closed = json['closed'];
    config = json['config'];
    created = json['created'];
    credit = json['credit'];
    forceAdult = json['force_adult'];
    id = json['id'];
    isCreditConsistent = json['is_credit_consistent'];
    isMobilePaymentActive = json['is_mobile_payment_active'];
    mergedInto = json['merged_into'];
    name = json['name'];
    shouldPayActivationFees = json['should_pay_activation_fees'];
    tag = json['tag'] != null ? Tag.fromJson(json['tag']) : null;
    updated = json['updated'];
    user = Owner.fromJson(json['user']);
  }

  bool? autoEnableMobilePayment;
  late Balances balances;
  late bool blocked;
  String? closed;
  num? config;
  String? created;
  late num credit;
  bool? forceAdult;
  late num id;
  bool? isCreditConsistent;
  bool? isMobilePaymentActive;
  dynamic mergedInto;
  String? name;
  bool? shouldPayActivationFees;
  Tag? tag;
  String? updated;
  late Owner user;
}

/// email : "tom.jumel@etu.utc.fr"
/// first_name : "Tom"
/// id : 27930
/// last_name : "JUMEL"
/// organisation : ""
/// phone : ""
/// photo_url : ""
/// username : "jumeltom"

class Owner {
  Owner({
    this.email,
    this.firstName,
    this.id,
    this.lastName,
    this.organisation,
    this.phone,
    this.photoUrl,
    this.username,
  });

  Owner.fromJson(dynamic json) {
    email = json['email'];
    firstName = json['first_name'];
    id = json['id'];
    lastName = json['last_name'];
    organisation = json['organisation'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
    username = json['username'];
  }

  String? email;
  String? firstName;
  num? id;
  String? lastName;
  String? organisation;
  String? phone;
  String? photoUrl;
  String? username;

  Owner copyWith({
    String? email,
    String? firstName,
    num? id,
    String? lastName,
    String? organisation,
    String? phone,
    String? photoUrl,
    String? username,
  }) =>
      Owner(
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        id: id ?? this.id,
        lastName: lastName ?? this.lastName,
        organisation: organisation ?? this.organisation,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        username: username ?? this.username,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['first_name'] = firstName;
    map['id'] = id;
    map['last_name'] = lastName;
    map['organisation'] = organisation;
    map['phone'] = phone;
    map['photo_url'] = photoUrl;
    map['username'] = username;
    return map;
  }
}

/// id : 21741
/// short_tag : null
/// tag : "04303EAAC96F80"
/// tag_group : null

class Tag {
  Tag({
    this.id,
    this.shortTag,
    this.tag,
    this.tagGroup,
  });

  Tag.fromJson(dynamic json) {
    id = json['id'];
    shortTag = json['short_tag'];
    tag = json['tag'];
    tagGroup = json['tag_group'];
  }

  num? id;
  dynamic shortTag;
  String? tag;
  dynamic tagGroup;

  Tag copyWith({
    num? id,
    dynamic shortTag,
    String? tag,
    dynamic tagGroup,
  }) =>
      Tag(
        id: id ?? this.id,
        shortTag: shortTag ?? this.shortTag,
        tag: tag ?? this.tag,
        tagGroup: tagGroup ?? this.tagGroup,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['short_tag'] = shortTag;
    map['tag'] = tag;
    map['tag_group'] = tagGroup;
    return map;
  }
}

/// card_credit : 820
/// created : "2022-09-01T17:37:12.281686Z"
/// credit : 820
/// currency : 1
/// id : 46780
/// updated : "2022-09-15T08:45:38.830450Z"

class Balances {
  Balances({
    this.cardCredit,
    this.created,
    this.credit,
    this.currency,
    this.id,
    this.updated,
  });

  Balances.fromJson(dynamic json) {
    cardCredit = json['card_credit'];
    created = json['created'];
    credit = json['credit'];
    currency = json['currency'];
    id = json['id'];
    updated = json['updated'];
  }

  num? cardCredit;
  String? created;
  num? credit;
  num? currency;
  num? id;
  String? updated;

  Balances copyWith({
    num? cardCredit,
    String? created,
    num? credit,
    num? currency,
    num? id,
    String? updated,
  }) =>
      Balances(
        cardCredit: cardCredit ?? this.cardCredit,
        created: created ?? this.created,
        credit: credit ?? this.credit,
        currency: currency ?? this.currency,
        id: id ?? this.id,
        updated: updated ?? this.updated,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_credit'] = cardCredit;
    map['created'] = created;
    map['credit'] = credit;
    map['currency'] = currency;
    map['id'] = id;
    map['updated'] = updated;
    return map;
  }
}
