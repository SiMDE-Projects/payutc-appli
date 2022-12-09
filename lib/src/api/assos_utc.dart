import 'package:dio/dio.dart';

class AssosUTC {
  //dio get https://assos.utc.fr/api/v1/semesters
  static Future<List<Semester>> getSemesters() async {
    final response = await Dio().get('https://assos.utc.fr/api/v1/semesters');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map<Semester>((e) => Semester.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load semesters');
    }
  }
}

//{
// "id": "052f21d0-6c88-11ec-9f69-2306293b178e",
// "name": "A22",
// "is_spring": false,
// "begin_at": "2022-09-01 00:00:00",
// "end_at": "2023-01-31 23:59:59"
// }
class Semester {
  final String id;
  final String name;
  final bool isSpring;
  final DateTime beginAt;
  final DateTime endAt;

  Semester({
    required this.id,
    required this.name,
    required this.isSpring,
    required this.beginAt,
    required this.endAt,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      name: json['name'],
      isSpring: json['is_spring'],
      beginAt: DateTime.parse(json['begin_at']),
      endAt: DateTime.parse(json['end_at']),
    );
  }
}
