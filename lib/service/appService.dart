import 'dart:convert';

import 'package:quotes/model/quotesData.dart';
import 'package:http/http.dart' as http;

class FetchApi {
  Future<Quote> fetchQuote() async {
    String baseUrl = "https://api.quotable.io/random";
    var response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Quote quote = Quote.fromJson(data);
      return quote;
    } else {
      throw Exception("Failed to fetch Quote");
    }
  }
}
