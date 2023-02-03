import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:logger_flutter_viewer/logger_flutter_viewer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/component/ui_utils.dart';
import 'package:payutc/src/ui/screen/splash.dart';
import 'package:payutc/src/ui/screen/sub_account_screen/account_settings_screen.dart';
import 'package:payutc/src/ui/style/color.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  Text(
                    Translate.of(context).settings,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.scaffoldDark,
                              foregroundColor: Colors.white,
                              child: Text(
                                  "${_getFirst(AppService.instance.user.firstName)}${_getFirst(AppService.instance.user.lastName ?? "U")}"
                                      .toUpperCase()),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppService.instance.userWallet!.user.firstName!} ${AppService.instance.userWallet!.user.lastName!}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${AppService.instance.userWallet!.user.username}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) =>
                                            const AccountSettingsPage()));
                              },
                              icon: const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldDark,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const LanguageSwitcher(),
                      ),
                      btnAccount(Translate.of(context).aPropos, _aproposScreen),
                      btnAccount(
                        Translate.of(context).nousContacter,
                        () async {
                          final info = await PackageInfo.fromPlatform();
                          StringBuffer sb = StringBuffer();
                          sb.writeln("------------------");
                          sb.writeln("Version : ${info.version}");
                          sb.writeln("Build : ${info.buildNumber}");
                          sb.writeln("OS : ${Platform.operatingSystem}");
                          sb.writeln(
                              "User : ${AppService.instance.user.username}");
                          sb.writeln("------------------");
                          launchUrlString(
                            "mailto:payutc@assos.utc.fr?subject=[App]&body=$sb\nBonjour,\n",
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      if (showLogConsole)
                        btnAccount("Console", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const LogConsole(
                                        dark: false,
                                        showCloseButton: true,
                                      )));
                        }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await AppService.instance.storageService.clear();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (builder) => const SplashPage()),
                          (route) => false);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Translate.of(context).logOut,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _aproposScreen() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (builder) => const APropos()));
  }

  _getFirst(String? firstName) {
    if (firstName == null) {
      return "U";
    }
    if (firstName.length == 1) {
      return firstName;
    }
    return firstName.substring(0, 1);
  }
}

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher>
    with TickerProviderStateMixin {
  Map<String, Locale> localesMap = {};
  TabController? _localeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshLocal();
      _localeController = TabController(length: localesMap.length, vsync: this);
      _localeController!.index = localesMap.values.toList().indexWhere(
            (element) =>
                element.languageCode ==
                Localizations.localeOf(context).languageCode,
          );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Translate.of(context).language,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 5,
        ),
        if (_localeController != null)
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(5),
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
              onTap: (_) {
                AppService.instance.setLocale(localesMap.values.elementAt(_));
                _refreshLocal();
              },
              controller: _localeController,
              tabs: [
                for (final l in localesMap.entries)
                  Tab(
                    child: Text(l.key),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _refreshLocal() {
    localesMap = {
      "French": const Locale('fr'),
      "English": const Locale('en'),
      "German": const Locale('de'),
      "Spanish": const Locale('es'),
    };
  }
}
