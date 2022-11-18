import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

void installCertificate(Dio dio, String certificate) {
  dio.interceptors.add(
    CertificatePinningInterceptor(
      allowedSHAFingerprints: [certificate],
    ),
  );
}

//security context
void addNemopayCert(Dio dio) {
  return installCertificate(dio, "1A:85:E0:F6:95:2A:D2:60:55:79:E7:F2:CE:85:BF:72:94:67:4D:7A:4C:25:61:26:67:E4:DF:35:21:23:F1:C5");
}
