import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

Dio installCertificate(Dio dio, String certificate){
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
    client.badCertificateCallback=(X509Certificate cert, String host, int port) {
      log(cert.pem);
      return cert.pem==certificate;
    };
  };
  return dio;
}

Dio addNemopayCert(Dio dio){
  return installCertificate(dio, "");
}