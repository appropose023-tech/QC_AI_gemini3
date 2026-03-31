import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://104.154.76.47:8000/";

  Future<Map?> upload(File img) async {
    final uri = Uri.parse("${baseUrl}compare_live");

    final req = http.MultipartRequest("POST", uri);
    req.files.add(await http.MultipartFile.fromPath("file", img.path));

    final res = await req.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return json.decode(body);
    }
    return null;
  }
}
