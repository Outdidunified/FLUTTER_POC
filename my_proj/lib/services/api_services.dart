import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.1.32:4444/profile';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/CheckLoginCredentials"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email_id': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        print("data:$data");
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful!',
          'data': data, // Include parsed response data if needed
        };
      } else {
        // Handle failed login
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to login',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Handle exceptions
      return {'success': false, 'message': 'Error: $e'};
    }
  }


  Future<Map<String, dynamic>> Register(String username, String email, String phone_no, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/RegisterNewUser"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username":username, 'email_id': email, "phone_no":phone_no, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        print("data:$data");
        return {
          'success': true,
          'message': data['message'] ?? 'Registered successful!',
          'data': data, // Include parsed response data if needed
        };
      } else {
        // Handle failed login
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to Register',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Handle exceptions
      return {'success': false, 'message': 'Error: $e'};
    }
  }


}
