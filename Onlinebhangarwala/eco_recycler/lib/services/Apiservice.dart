import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'https://backend.onlinebhangarwala.com/api/';

  Future<String> _getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<http.Response> Login(String username, String password) async {
    final url = Uri.parse(_baseUrl + "dologin");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    return response;
  }

  Future<http.Response> GetEcoRecyclerPickUP() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetEcoRecyclerPickUP");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully fetched the data
        return response;
      } else {
        // Handle other status codes
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoriesWithPrices() async {
    final String _bearerToken = await _getBearerToken();

    final response = await http.get(
      Uri.parse(_baseUrl + "GetAllSubCategory"),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data
          .map((item) => {
                'sub_id': item['id'],
                'name': item['name'],
                'price': item['price'],
                'per': item['per_kg']
              })
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<http.Response> CompleteOrderByEco(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "CompleteOrderByEco");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<http.Response> RejectOrder(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "RejectOrder");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<http.Response> DateWiseOrder(String date) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "DateWiseOrder");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, String>{
        'date': date,
      }),
    );
    return response;
  }

  Future<http.Response> Allpickups() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "CompleteCancelEco");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully fetched the data
        return response;
      } else {
        // Handle other status codes
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> GetPickUPDetails(String pickupId) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetPickUPDetails");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, int>{
        'id': int.parse(pickupId),
      }),
    );
    return response;
  }

  Future<http.Response> Userinfoeco() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "userinfoeco");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
    );
    return response;
  }

  Future<http.Response> UpdateStatus(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "UpdateStatus");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<http.Response> checkCoupon(
    String couponCode,
    String totalAmount,
  ) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "getspecificCoupan");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, String>{
        'coupon_code': couponCode,
        'sell_amount': double.parse(totalAmount).toString(), // Corrected here
      }),
    );
    return response;
  }

  Future<http.Response> GetSpecifiCoupon(String Id) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "getPaCoupon");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, int>{
        'id': int.parse(Id),
      }),
    );
    return response;
  }
}
