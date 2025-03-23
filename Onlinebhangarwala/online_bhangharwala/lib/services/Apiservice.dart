import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'https://backend.onlinebhangarwala.com/api/';

  Future<String> _getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<http.Response> checkAvailability(String pin) async {
    final url = Uri.parse(_baseUrl + "Checkavailability");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pin': pin,
      }),
    );
    return response;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "newuserinfo");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<Map<String, dynamic>> getUserInfoDetail() async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "userinfo");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
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
          .map((item) => {'name': item['name'], 'price': item['price']})
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<http.Response> sendOtp(String mobile) async {
    final url =
        Uri.parse('https://backend.onlinebhangarwala.com/api/regloginforapp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile': mobile}),
    );

    return response;
  }

  Future<http.Response> resendOtp(String mobile) async {
    final url =
        Uri.parse('https://backend.onlinebhangarwala.com/api/resendotp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile': mobile}),
    );

    return response;
  }

  Future<http.Response> userLogin(String mobile, String otp) async {
    final url =
        Uri.parse('https://backend.onlinebhangarwala.com/api/verifyOtpapp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'mobile': mobile, 'otp': otp}),
    );

    return response;
  }

  Future<bool> updateAppProfile(String name) async {
  final String _bearerToken = await _getBearerToken();
  final userdetails = await getUserInfo();
  final userId = userdetails['user']['id']; 

  print('User ID: $userId');

  if (userId is! int) {
    throw Exception("Invalid user_id format. Expected an int.");
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user_id', userId); // Store as int
  await prefs.setString('name', name);

  final url = Uri.parse(_baseUrl + "updateAppProfile");
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_bearerToken',
    },
    body: jsonEncode(<String, dynamic>{
      'user_id': userId, 
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to update profile: ${response.body}');
  }
}

  Future<http.Response> AddAddress(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "updateAppProfile");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final body = jsonEncode(data);
    print(body);

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<http.Response> Pickup(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "PickUpData");
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

  Future<http.Response> GetSchedulePickUpData(String pickupId) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetSchedulePickUpData");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, String>{
        'id': pickupId,
      }),
    );
    return response;
  }

  Future<http.Response> ChangeSchedule(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "ChangeSchedule");
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

  Future<http.Response> Mypickups() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "Mypickups");

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

  Future<http.Response> Completecancel() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "Completecancel");

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

  Future<http.Response> CancelPickup(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "CancelPickup");
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

  Future<http.Response> GetPickUPDetails(String pickupId) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetPickUPDetails");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, String>{
        'id': pickupId,
      }),
    );
    return response;
  }

  Future<http.Response> getPickUpData() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetPickUpData");

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

  Future<http.Response> GetUserAddress() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetUserAddress");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> GetUserProfile() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetUserProfile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> UpdateProfile(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "MbUpdateProfile");
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

  Future<http.Response> DeleteAddress(int Id) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "DeleteAddress");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, int>{
        'id': Id,
      }),
    );
    return response;
  }

  Future<http.Response> GetAddress(int Id) async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetAddress");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
      body: jsonEncode(<String, int>{
        'id': Id,
      }),
    );
    return response;
  }

  Future<http.Response> UpdateAddress(Map<String, dynamic> data) async {
    final String _bearerToken = await _getBearerToken();
    final url = Uri.parse(_baseUrl + "UpdateAddress");
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

  Future<http.Response> GetCoupoonValue() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetCoupoonValue");

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

  Future<http.Response> GetTimeSlot() async {
    final String _bearerToken = await _getBearerToken();

    final url = Uri.parse(_baseUrl + "GetTimeSlot");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
