import 'package:http/http.dart' as http;

fetchData(String url) async {
  Uri uri = Uri.parse(url);
  var response = await http.get(uri);
  if (response.statusCode == 200) {
  } else {}
}
