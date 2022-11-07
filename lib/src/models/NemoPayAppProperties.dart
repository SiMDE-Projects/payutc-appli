/// config : {"cappuccino_url":"wss://127.0.0.1:9192/events","cas_url":"https://cas.utc.fr/cas/","currency_symbol":"€","enable_cotisant":true,"login_mode":"both","nb_decimal":2,"system_name":"payutc"}
/// id : 1060
/// name : "Application officielle PayUTC v1.0.0"

class NemoPayAppProperties {
  NemoPayAppProperties({
    this.config,
    this.id,
    this.name,
  });

  NemoPayAppProperties.fromJson(dynamic json) {
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
    id = json['id'];
    name = json['name'];
  }
  Config? config;
  num? id;
  String? name;
  NemoPayAppProperties copyWith({
    Config? config,
    num? id,
    String? name,
  }) =>
      NemoPayAppProperties(
        config: config ?? this.config,
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (config != null) {
      map['config'] = config?.toJson();
    }
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

/// cappuccino_url : "wss://127.0.0.1:9192/events"
/// cas_url : "https://cas.utc.fr/cas/"
/// currency_symbol : "€"
/// enable_cotisant : true
/// login_mode : "both"
/// nb_decimal : 2
/// system_name : "payutc"

class Config {
  Config({
    this.cappuccinoUrl,
    this.casUrl,
    this.currencySymbol,
    this.enableCotisant,
    this.loginMode,
    this.nbDecimal,
    this.systemName,
  });

  Config.fromJson(dynamic json) {
    cappuccinoUrl = json['cappuccino_url'];
    casUrl = json['cas_url'];
    currencySymbol = json['currency_symbol'];
    enableCotisant = json['enable_cotisant'];
    loginMode = json['login_mode'];
    nbDecimal = json['nb_decimal'];
    systemName = json['system_name'];
  }
  String? cappuccinoUrl;
  String? casUrl;
  String? currencySymbol;
  bool? enableCotisant;
  String? loginMode;
  num? nbDecimal;
  String? systemName;
  Config copyWith({
    String? cappuccinoUrl,
    String? casUrl,
    String? currencySymbol,
    bool? enableCotisant,
    String? loginMode,
    num? nbDecimal,
    String? systemName,
  }) =>
      Config(
        cappuccinoUrl: cappuccinoUrl ?? this.cappuccinoUrl,
        casUrl: casUrl ?? this.casUrl,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        enableCotisant: enableCotisant ?? this.enableCotisant,
        loginMode: loginMode ?? this.loginMode,
        nbDecimal: nbDecimal ?? this.nbDecimal,
        systemName: systemName ?? this.systemName,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cappuccino_url'] = cappuccinoUrl;
    map['cas_url'] = casUrl;
    map['currency_symbol'] = currencySymbol;
    map['enable_cotisant'] = enableCotisant;
    map['login_mode'] = loginMode;
    map['nb_decimal'] = nbDecimal;
    map['system_name'] = systemName;
    return map;
  }
}
