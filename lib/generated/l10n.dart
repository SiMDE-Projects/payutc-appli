// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Translate {
  Translate();

  static Translate? _current;

  static Translate get current {
    assert(_current != null,
        'No instance of Translate was loaded. Try to initialize the Translate delegate before accessing Translate.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Translate> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Translate();
      Translate._current = instance;

      return instance;
    });
  }

  static Translate of(BuildContext context) {
    final instance = Translate.maybeOf(context);
    assert(instance != null,
        'No instance of Translate present in the widget tree. Did you add Translate.delegate in localizationsDelegates?');
    return instance!;
  }

  static Translate? maybeOf(BuildContext context) {
    return Localizations.of<Translate>(context, Translate);
  }

  /// `Mon Pay'UTC`
  String get myPayutc {
    return Intl.message(
      'Mon Pay\'UTC',
      name: 'myPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Recharger`
  String get reload {
    return Intl.message(
      'Recharger',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `Envoyer`
  String get send {
    return Intl.message(
      'Envoyer',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Recevoir`
  String get receive {
    return Intl.message(
      'Recevoir',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `Historique`
  String get history {
    return Intl.message(
      'Historique',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get statistics {
    return Intl.message(
      'Stats',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Activit??`
  String get activity {
    return Intl.message(
      'Activit??',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `Voir mon historique`
  String get see_history_sentence {
    return Intl.message(
      'Voir mon historique',
      name: 'see_history_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Fait scanner le code avec l'application Pay'UTC pour partager ton profil.`
  String get receiveMoneyScanSentence {
    return Intl.message(
      'Fait scanner le code avec l\'application Pay\'UTC pour partager ton profil.',
      name: 'receiveMoneyScanSentence',
      desc: '',
      args: [],
    );
  }

  /// `Montant de la recharge`
  String get reloadAmount {
    return Intl.message(
      'Montant de la recharge',
      name: 'reloadAmount',
      desc: '',
      args: [],
    );
  }

  /// `S??lectionner un utilisateur`
  String get select_user {
    return Intl.message(
      'S??lectionner un utilisateur',
      name: 'select_user',
      desc: '',
      args: [],
    );
  }

  /// `Scanner`
  String get scan {
    return Intl.message(
      'Scanner',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Favoris`
  String get favoris {
    return Intl.message(
      'Favoris',
      name: 'favoris',
      desc: '',
      args: [],
    );
  }

  /// `Aucun favoris enregistr??`
  String get noFavorisFound {
    return Intl.message(
      'Aucun favoris enregistr??',
      name: 'noFavorisFound',
      desc: '',
      args: [],
    );
  }

  /// `Transfert r??cents`
  String get recentTransfert {
    return Intl.message(
      'Transfert r??cents',
      name: 'recentTransfert',
      desc: '',
      args: [],
    );
  }

  /// `Aucun transfert r??cent`
  String get noTransfertFound {
    return Intl.message(
      'Aucun transfert r??cent',
      name: 'noTransfertFound',
      desc: '',
      args: [],
    );
  }

  /// `Enlever des favoris`
  String get removeFromFav {
    return Intl.message(
      'Enlever des favoris',
      name: 'removeFromFav',
      desc: '',
      args: [],
    );
  }

  /// `Ajouter aux favoris`
  String get addToFav {
    return Intl.message(
      'Ajouter aux favoris',
      name: 'addToFav',
      desc: '',
      args: [],
    );
  }

  /// `Supprimer de mon historique`
  String get deleteRecentTransfert {
    return Intl.message(
      'Supprimer de mon historique',
      name: 'deleteRecentTransfert',
      desc: '',
      args: [],
    );
  }

  /// `Un gentil message plein d'amour`
  String get helpMessageTransfert {
    return Intl.message(
      'Un gentil message plein d\'amour',
      name: 'helpMessageTransfert',
      desc: '',
      args: [],
    );
  }

  /// `Phrase al??atoire`
  String get randomTransfertSentence {
    return Intl.message(
      'Phrase al??atoire',
      name: 'randomTransfertSentence',
      desc: '',
      args: [],
    );
  }

  /// `0??? s??rieux ? Radin va`
  String get nothingToTransfert {
    return Intl.message(
      '0??? s??rieux ? Radin va',
      name: 'nothingToTransfert',
      desc: '',
      args: [],
    );
  }

  /// `C'est pour envoyer l'argent l??.`
  String get authReasonTransfert {
    return Intl.message(
      'C\'est pour envoyer l\'argent l??.',
      name: 'authReasonTransfert',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur est survenue`
  String get splashError {
    return Intl.message(
      'Une erreur est survenue',
      name: 'splashError',
      desc: '',
      args: [],
    );
  }

  /// `RESSAYER`
  String get ressayer {
    return Intl.message(
      'RESSAYER',
      name: 'ressayer',
      desc: '',
      args: [],
    );
  }

  /// `SE CONNECTER`
  String get splashConnect {
    return Intl.message(
      'SE CONNECTER',
      name: 'splashConnect',
      desc: '',
      args: [],
    );
  }

  /// `Chargement..`
  String get splashLoading {
    return Intl.message(
      'Chargement..',
      name: 'splashLoading',
      desc: '',
      args: [],
    );
  }

  /// `Se connecter\n?? Pay'UTC`
  String get connectToPayutc {
    return Intl.message(
      'Se connecter\n?? Pay\'UTC',
      name: 'connectToPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Connectez-vous pour utiliser l'application Pay'UTC`
  String get connectToPayutcSentence {
    return Intl.message(
      'Connectez-vous pour utiliser l\'application Pay\'UTC',
      name: 'connectToPayutcSentence',
      desc: '',
      args: [],
    );
  }

  /// `Nom d'utilisateur`
  String get userName {
    return Intl.message(
      'Nom d\'utilisateur',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Mot de passe`
  String get password {
    return Intl.message(
      'Mot de passe',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Mauvais mot de passe`
  String get badPassword {
    return Intl.message(
      'Mauvais mot de passe',
      name: 'badPassword',
      desc: '',
      args: [],
    );
  }

  /// `Se connecter`
  String get connect {
    return Intl.message(
      'Se connecter',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Rechargement`
  String get reloading {
    return Intl.message(
      'Rechargement',
      name: 'reloading',
      desc: '',
      args: [],
    );
  }

  /// `Virement`
  String get transfertPayutc {
    return Intl.message(
      'Virement',
      name: 'transfertPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Envoy??`
  String get sendedTransfertPayutc {
    return Intl.message(
      'Envoy??',
      name: 'sendedTransfertPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Re??u`
  String get reveivedTransfertPayutc {
    return Intl.message(
      'Re??u',
      name: 'reveivedTransfertPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Ta carte bleue`
  String get yourCard {
    return Intl.message(
      'Ta carte bleue',
      name: 'yourCard',
      desc: '',
      args: [],
    );
  }

  /// `Aujourd'hui`
  String get today {
    return Intl.message(
      'Aujourd\'hui',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Hier`
  String get yesterday {
    return Intl.message(
      'Hier',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Tout`
  String get all {
    return Intl.message(
      'Tout',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Consomation`
  String get consomation {
    return Intl.message(
      'Consomation',
      name: 'consomation',
      desc: '',
      args: [],
    );
  }

  /// `Transferts`
  String get historytransferts {
    return Intl.message(
      'Transferts',
      name: 'historytransferts',
      desc: '',
      args: [],
    );
  }

  /// `Recharges`
  String get historyReloads {
    return Intl.message(
      'Recharges',
      name: 'historyReloads',
      desc: '',
      args: [],
    );
  }

  /// `Autre`
  String get other {
    return Intl.message(
      'Autre',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Montant du transfert`
  String get transfert_montant_select_amount {
    return Intl.message(
      'Montant du transfert',
      name: 'transfert_montant_select_amount',
      desc: '',
      args: [],
    );
  }

  /// `Valider`
  String get validate {
    return Intl.message(
      'Valider',
      name: 'validate',
      desc: '',
      args: [],
    );
  }

  /// `Impossible d'ex??cuter ce transfert`
  String get transfert_error {
    return Intl.message(
      'Impossible d\'ex??cuter ce transfert',
      name: 'transfert_error',
      desc: '',
      args: [],
    );
  }

  /// `Non`
  String get no {
    return Intl.message(
      'Non',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Oui`
  String get yes {
    return Intl.message(
      'Oui',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Quitter la page ?`
  String get quitterLaPage {
    return Intl.message(
      'Quitter la page ?',
      name: 'quitterLaPage',
      desc: '',
      args: [],
    );
  }

  /// `Langue`
  String get language {
    return Intl.message(
      'Langue',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Fran??ais`
  String get fr_lang {
    return Intl.message(
      'Fran??ais',
      name: 'fr_lang',
      desc: '',
      args: [],
    );
  }

  /// `Anglais`
  String get en_lang {
    return Intl.message(
      'Anglais',
      name: 'en_lang',
      desc: '',
      args: [],
    );
  }

  /// `Allemand`
  String get de_lang {
    return Intl.message(
      'Allemand',
      name: 'de_lang',
      desc: '',
      args: [],
    );
  }

  /// `Espagnol`
  String get es_lang {
    return Intl.message(
      'Espagnol',
      name: 'es_lang',
      desc: '',
      args: [],
    );
  }

  /// `Mentions l??gales`
  String get mentionsLgales {
    return Intl.message(
      'Mentions l??gales',
      name: 'mentionsLgales',
      desc: '',
      args: [],
    );
  }

  /// `Licence Pay'UTC`
  String get licensesPayutc {
    return Intl.message(
      'Licence Pay\'UTC',
      name: 'licensesPayutc',
      desc: '',
      args: [],
    );
  }

  /// `Licence de l'application`
  String get licenseDeLapplication {
    return Intl.message(
      'Licence de l\'application',
      name: 'licenseDeLapplication',
      desc: '',
      args: [],
    );
  }

  /// `A propos`
  String get aPropos {
    return Intl.message(
      'A propos',
      name: 'aPropos',
      desc: '',
      args: [],
    );
  }

  /// `Se d??connecter`
  String get logOut {
    return Intl.message(
      'Se d??connecter',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Nous contacter`
  String get nousContacter {
    return Intl.message(
      'Nous contacter',
      name: 'nousContacter',
      desc: '',
      args: [],
    );
  }

  /// `Param??tres`
  String get settings {
    return Intl.message(
      'Param??tres',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Scanner un qr code payutc`
  String get scannPayutcCode {
    return Intl.message(
      'Scanner un qr code payutc',
      name: 'scannPayutcCode',
      desc: '',
      args: [],
    );
  }

  /// `Informations`
  String get informations {
    return Intl.message(
      'Informations',
      name: 'informations',
      desc: '',
      args: [],
    );
  }

  /// `Nom`
  String get name {
    return Intl.message(
      'Nom',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Pr??nom`
  String get lastname {
    return Intl.message(
      'Pr??nom',
      name: 'lastname',
      desc: '',
      args: [],
    );
  }

  /// `Nom d'utilisateur`
  String get user_name_texxt {
    return Intl.message(
      'Nom d\'utilisateur',
      name: 'user_name_texxt',
      desc: '',
      args: [],
    );
  }

  /// `Adulte`
  String get adult {
    return Intl.message(
      'Adulte',
      name: 'adult',
      desc: '',
      args: [],
    );
  }

  /// `Vous ??tes cotisant BDE-UTC !`
  String get is_contributor {
    return Intl.message(
      'Vous ??tes cotisant BDE-UTC !',
      name: 'is_contributor',
      desc: '',
      args: [],
    );
  }

  /// `Vous n'??tes pas cotisant BDE-UTC`
  String get is_not_contributor {
    return Intl.message(
      'Vous n\'??tes pas cotisant BDE-UTC',
      name: 'is_not_contributor',
      desc: '',
      args: [],
    );
  }

  /// `??tre cotisant permet d'acc??der ?? la MDE, au Picasso et aux ??venements organis??s par le BDE. Cela apporte ??galement des avantages aupr??s des commer??ants Compi??gnois.`
  String get contributor_desc {
    return Intl.message(
      '??tre cotisant permet d\'acc??der ?? la MDE, au Picasso et aux ??venements organis??s par le BDE. Cela apporte ??galement des avantages aupr??s des commer??ants Compi??gnois.',
      name: 'contributor_desc',
      desc: '',
      args: [],
    );
  }

  /// `Lorsque le badge est verrouill??, il ne peut plus ??tre utilis?? pour payer.`
  String get lock_info {
    return Intl.message(
      'Lorsque le badge est verrouill??, il ne peut plus ??tre utilis?? pour payer.',
      name: 'lock_info',
      desc: '',
      args: [],
    );
  }

  /// `Mon compte`
  String get myAccount {
    return Intl.message(
      'Mon compte',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `Cotisation`
  String get cotiz {
    return Intl.message(
      'Cotisation',
      name: 'cotiz',
      desc: '',
      args: [],
    );
  }

  /// `Mon Badge`
  String get myCard {
    return Intl.message(
      'Mon Badge',
      name: 'myCard',
      desc: '',
      args: [],
    );
  }

  /// `(Badge verrouill??)`
  String get card_blocked {
    return Intl.message(
      '(Badge verrouill??)',
      name: 'card_blocked',
      desc: '',
      args: [],
    );
  }

  /// `En vous connectant vous acceptez les`
  String get connect_mention_legs {
    return Intl.message(
      'En vous connectant vous acceptez les',
      name: 'connect_mention_legs',
      desc: '',
      args: [],
    );
  }

  /// `Verrouiller mon badge`
  String get lock_card {
    return Intl.message(
      'Verrouiller mon badge',
      name: 'lock_card',
      desc: '',
      args: [],
    );
  }

  /// `S??lectionner`
  String get select {
    return Intl.message(
      'S??lectionner',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Ajouter aux favoris`
  String get addtofav {
    return Intl.message(
      'Ajouter aux favoris',
      name: 'addtofav',
      desc: '',
      args: [],
    );
  }

  /// `Annuler`
  String get annuler {
    return Intl.message(
      'Annuler',
      name: 'annuler',
      desc: '',
      args: [],
    );
  }

  /// `Utilisateur trouv?? !`
  String get userFound {
    return Intl.message(
      'Utilisateur trouv?? !',
      name: 'userFound',
      desc: '',
      args: [],
    );
  }

  /// `Erreur de lecture du QR code`
  String get qr_read_error {
    return Intl.message(
      'Erreur de lecture du QR code',
      name: 'qr_read_error',
      desc: '',
      args: [],
    );
  }

  /// `Commencer un transfert`
  String get beginTransfert {
    return Intl.message(
      'Commencer un transfert',
      name: 'beginTransfert',
      desc: '',
      args: [],
    );
  }

  /// `Champ requis`
  String get fieldNeeded {
    return Intl.message(
      'Champ requis',
      name: 'fieldNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Impossible de rafraichir, une erreur est survenue`
  String get refreshContentError {
    return Intl.message(
      'Impossible de rafraichir, une erreur est survenue',
      name: 'refreshContentError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Translate> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Translate> load(Locale locale) => Translate.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
