import 'package:dio/dio.dart';
import 'package:payutc/src/models/ginger_user_infos.dart';

class Ginger {
  static Future<GingerUserInfos> getUserInfos(String user, String key) {
    return Dio().get("https://assos.utc.fr/ginger/v1/$user", queryParameters: {
      "key": key
    }).then((value) => GingerUserInfos.fromJson(value.data));
  }
}
