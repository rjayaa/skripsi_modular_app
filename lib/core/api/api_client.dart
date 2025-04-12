import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../utils/storage_service.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;
  final StorageService _storageService;

  ApiClient({http.Client? client, required StorageService storageService})
    : _client = client ?? http.Client(),
      _storageService = storageService;

  // Base headers for requests
  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _storageService.getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request
  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await _client.get(url, headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await _client.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await _client.put(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await _client.delete(url, headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Process API response
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      final errorBody =
          response.body.isNotEmpty
              ? jsonDecode(response.body)
              : {'message': 'Unknown error occurred'};

      switch (response.statusCode) {
        case 400:
          throw BadRequestException(errorBody['message'] ?? 'Bad request');
        case 401:
          throw UnauthorizedException(errorBody['message'] ?? 'Unauthorized');
        case 403:
          throw ForbiddenException(errorBody['message'] ?? 'Forbidden');
        case 404:
          throw NotFoundException(errorBody['message'] ?? 'Not found');
        case 500:
        default:
          throw ServerException(errorBody['message'] ?? 'Server error');
      }
    }
  }

  // Handle client-side errors
  Exception _handleError(dynamic e) {
    if (kDebugMode) {
      print('API Error: $e');
    }
    return NetworkException('Network error occurred: ${e.toString()}');
  }
}
