import 'package:flutter/material.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/models/ginger_user_infos.dart';
import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/component/ui_utils.dart';
import 'package:payutc/src/ui/style/color.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translate.of(context).myAccount),
        ),
        body: FutureBuilder<GingerUserInfos>(
          future: AppService.instance.getGingerInfos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              GingerUserInfos infos = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Wrap(
                  runSpacing: 6,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Translate.of(context).informations,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _row(Translate.of(context).name, infos.nom!),
                          _row(Translate.of(context).lastname, infos.prenom!),
                          _row(Translate.of(context).user_name_texxt,
                              infos.login!),
                          _row(
                            Translate.of(context).adult,
                            (infos.isAdulte == true
                                ? Translate.of(context).yes
                                : Translate.of(context).no),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Translate.of(context).cotiz,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${infos.isCotisant! ? "✅" : "❌"} ${infos.isCotisant! ? Translate.of(context).is_contributor : Translate.of(context).is_not_contributor}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            Translate.of(context).contributor_desc,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Translate.of(context).myCard,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _badge(),
                          Text(
                            Translate.of(context).lock_info,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  _row(String s, String t) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            s,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            t,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      );

  _badge() {
    bool block = AppService.instance.userWallet!.blocked;
    return StatefulBuilder(builder: (context, state) {
      return SwitchListTile(
        activeColor: AppColors.red,
        inactiveTrackColor: Colors.white70,
        title: Text(
          Translate.of(context).lock_card,
          style: const TextStyle(color: Colors.white),
        ),
        onChanged: (bool value) {
          block = value;
          state(() {});
          AppService.instance.changeBadgeState(value).then(
                (value) => AppService.instance.userWallet!.blocked = value,
              );
        },
        value: block,
      );
    });
  }
}

class APropos extends StatelessWidget {
  const APropos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context).aPropos),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          runSpacing: 6,
          children: [
            btnAccount(
              "Remercier le développer",
              () {
                showUserCard(
                  context,
                  User.fromJson(
                    {
                      "email": "tom.jumel@etu.utc.fr",
                      "id": 27930,
                      "name": "Tom JUMEL (jumeltom)"
                    },
                  ),
                );
              },
            ),
            btnAccount(
              Translate.of(context).mentionsLgales,
              () {
                showWebView(
                  context,
                  "assets/therms/cgu.html",
                  Translate.of(context).mentionsLgales,
                );
              },
            ),
            btnAccount(
              Translate.of(context).licensesPayutc,
              () {
                showWebView(
                  context,
                  "assets/therms/gnu.html",
                  Translate.of(context).licensesPayutc,
                );
              },
            ),
            btnAccount(
              Translate.of(context).licenseDeLapplication,
              () {
                showLicensePage(
                  context: context,
                  applicationName: "Pay'ut",
                  applicationIcon: Image.asset(
                    "assets/img/logo.jpg",
                    height: 100,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
