import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/search_user_manager.dart';
import 'package:payutc/src/services/unilinks.dart';
import 'package:payutc/src/ui/style/color.dart';
import 'package:qr_flutter/qr_flutter.dart';

typedef SelectUserCallBack = void Function(BuildContext context, User user);

class SelectUserPage extends StatefulWidget {
  final SelectUserCallBack? callBack;

  const SelectUserPage({Key? key, this.callBack}) : super(key: key);

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  SearchUserManagerService favManager = SearchUserManagerService.favManager,
      histManager = SearchUserManagerService.historyManager;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    searchController.addListener(() {
      _search(searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(Translate.of(context).select_user),
        leading: IconButton(
          onPressed: () {
            if (showSearchContent) {
              searchController.clear();
              return;
            }
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: AppColors.black,
          ),
        ),
      ),
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistantHeader(
                builder: (overlap) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        TextField(
                          focusNode: focusNode,
                          controller: searchController,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: IconButton(
                              padding: const EdgeInsets.only(left: 6),
                              icon: const Icon(Icons.search),
                              iconSize: 26,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(focusNode);
                              },
                            ),
                            suffixIcon: Visibility(
                              visible: showSearchContent,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 24,
                                onPressed: () {
                                  searchController.clear();
                                },
                              ),
                            ),
                            hintText: "Jean Dupont, ...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.black,
                            elevation: 0,
                          ),
                          label: Text(
                            Translate.of(context).scan,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            String? data = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (builder) => const ScanPage()));
                            if (data == null) return;
                            _handleUrl(data);
                          },
                          icon: const Icon(Icons.qr_code),
                        ),
                      ],
                    ),
                  );
                },
                height: 116,
              ),
            )
          ];
        },
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            if (showSearchContent) ...[
              if (users.isNotEmpty)
                for (final item in users) _buildUserCase(item)
              else if (showLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (users.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Aucun utilisateur trouvé"),
                  ),
                ),
            ] else ...[
              const SizedBox(
                height: 16,
              ),
              Text(
                Translate.of(context).favoris,
                style: const TextStyle(fontSize: 18),
              ),
              AnimatedBuilder(
                animation: favManager,
                builder: (context, child) {
                  if (favManager.users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(Translate.of(context).noFavorisFound),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        for (final e in favManager.users) _buildUserCase(e),
                      ],
                    );
                  }
                },
              ),

              // for (int i = 0; i < 10; i++) _buildUserCase(),
              const SizedBox(
                height: 16,
              ),
              Text(
                Translate.of(context).recentTransfert,
                style: const TextStyle(fontSize: 18),
              ),
              AnimatedBuilder(
                animation: histManager,
                builder: (context, child) {
                  if (histManager.users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(Translate.of(context).noTransfertFound),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        for (final e in histManager.users) _buildUserCase(e),
                      ],
                    );
                  }
                },
              ),
              // for (int i = 0; i < 10; i++) _buildUserCase(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildUserCase(User item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: () {
          popContent(item);
        },
        leading: CircleAvatar(
          child: Center(
            child: Text(item.maj),
          ),
        ),
        title: Text(item.name),
        subtitle: Text("@${item.subName}"),
        trailing: IconButton(
            onPressed: () {
              _showBottomUserSheet(item);
            },
            icon: const Icon(Icons.more_horiz)),
      ),
    );
  }

  void _showBottomUserSheet(User user) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (builder) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (favManager.exist(user))
                ListTile(
                  onTap: () {
                    favManager.remove(user);
                    Navigator.pop(context);
                  },
                  title: Text(Translate.of(context).removeFromFav),
                )
              else
                ListTile(
                  onTap: () {
                    favManager.add(user);
                    Navigator.pop(context);
                  },
                  title: Text(Translate.of(context).addToFav),
                ),
              if (histManager.exist(user))
                ListTile(
                  onTap: () {
                    histManager.remove(user);
                    Navigator.pop(context);
                  },
                  title: Text(Translate.of(context).deleteRecentTransfert),
                ),
            ],
          ),
        );
      },
    );
  }

  bool showSearchContent = false;
  bool showLoading = false;
  List<User> users = [];

  void _search(String text) async {
    scrollController.jumpTo(0);
    if (text.isEmpty) {
      showLoading = false;
      showSearchContent = false;
      focusNode.unfocus();
      return setState(() {});
    } else {
      showSearchContent = true;
    }
    showLoading = true;
    setState(() {});
    final data = await AppService.instance.nemoPayApi.searchForUser(text);
    data.removeWhere((element) => AppService.instance.user.id == element.id);
    if (showLoading) {
      users = data;
      showLoading = false;
      if (mounted) setState(() {});
    }
  }

  void popContent(User user) {
    if (widget.callBack != null) {
      return widget.callBack!(context, user);
    }
    return Navigator.pop(context, user);
  }

  void _handleUrl(String data) {
    User user;
    try {
      Uri uri = Uri.parse(data);
      user = UniLinks.handleTransfertUri(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translate.of(context).qr_read_error),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Translate.of(context).userFound,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: Text(user.maj),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "@${user.subName}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, elevation: 0),
                  onPressed: () {
                    Navigator.pop(context);
                    popContent(user);
                  },
                  child: Text(Translate.of(context).select),
                ),
                AnimatedBuilder(
                    animation: favManager,
                    builder: (context, snapshot) {
                      return TextButton(
                        onPressed: () {
                          if (favManager.exist(user)) {
                            favManager.remove(user);
                          } else {
                            favManager.add(user);
                          }
                        },
                        child: Text(
                          favManager.exist(user)
                              ? Translate.of(context).removeFromFav
                              : Translate.of(context).addtofav,
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(Translate.of(context).annuler),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          Translate.of(context).scan,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.scaffoldDark,
      body: FutureBuilder<PermissionStatus>(
        future: _checkPerm(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur est survenue"),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data == PermissionStatus.granted) {
              return _mobileScannerContent();
            }
            return const Center(
              child: Text(
                "Vous devez autoriser l'accès à la caméra dans les paramètres",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<PermissionStatus> _checkPerm() {
    return Permission.camera.request();
  }

  Widget _mobileScannerContent() => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              allowDuplicates: false,
              controller:
                  MobileScannerController(formats: [BarcodeFormat.qrCode]),
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                } else {
                  final String code = barcode.rawValue!;
                  Navigator.pop(context, code);
                }
              },
            ),
            ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 260.0,
                      maxHeight: 260.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Translate.of(context).scanPayutcCode,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 200.0)
                ],
              ),
            ),
          ],
        ),
      );
}

class PersistantHeader extends SliverPersistentHeaderDelegate {
  final Widget Function(bool overlap) builder;

  final double height;

  PersistantHeader({required this.builder, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(overlapsContent);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
