import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:app/core/api.dart';
import 'package:app/data/models/user/user_model.dart';

class UserRepository {
  final _api = Api();

  // Create account function
  Future<UserModel> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/user/createAccount",
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        // Check if the message indicates user already exists
        if (apiResponse.message != null &&
            apiResponse.message!.contains("already exists")) {
          // Throw specific exception for "User already exists"
          throw Exception("User already exists");
        }
        // Throw a general exception if it's any other failure
        throw Exception(apiResponse.message ?? "Account creation failed");
      }

      if (apiResponse.data is Map<String, dynamic>) {
        return UserModel.fromJson(apiResponse.data);
      } else {
        throw Exception("Unexpected data format");
      }
    } catch (ex) {
      // Log the exception and rethrow it
      rethrow;
    }
  }

  // SignIn function
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/user/signIn",
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? "Sign-in failed");
      }

      if (apiResponse.data is Map<String, dynamic>) {
        return UserModel.fromJson(apiResponse.data);
      } else {
        throw Exception("Unexpected data format");
      }
    } catch (ex) {
      rethrow;
    }
  }

  // Update user function
  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      Response response = await _api.sendRequest.put(
        "/user/${userModel.sId}",
        data: jsonEncode(userModel.toJson()),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? "User update failed");
      }

      if (apiResponse.data is Map<String, dynamic>) {
        return UserModel.fromJson(apiResponse.data);
      } else {
        throw Exception("Unexpected data format");
      }
    } catch (ex) {
      rethrow;
    }
  }
}
