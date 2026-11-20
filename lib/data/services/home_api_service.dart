import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../models/home_models.dart';

class HomeApiService {
  HomeApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 25),
                sendTimeout: const Duration(seconds: 20),
                responseType: ResponseType.json,
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;

  Future<HomeResponse> fetchHome() async {
    try {
      final response = await _dio.get<dynamic>(AppConstants.homeApiUrl);
      dynamic body = response.data;
      if (body is String) body = jsonDecode(body);

      if (body is! Map) {
        throw const FormatException('The home API did not return a JSON object.');
      }

      final parsed = HomeResponse.fromJson(asStringMap(body));
      if (!parsed.success) {
        throw Exception(
          parsed.message.isNotEmpty
              ? parsed.message
              : 'The server returned an unsuccessful response.',
        );
      }
      return parsed;
    } on DioException catch (error) {
      final responseBody = error.response?.data;
      final responseMap = responseBody is Map
          ? asStringMap(responseBody)
          : <String, dynamic>{};
      final serverMessage = readText(
        responseMap['message'] ?? responseMap['msg'] ?? responseMap['error'],
      );
      if (serverMessage.isNotEmpty) throw Exception(serverMessage);

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw Exception('The request timed out. Please try again.');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw Exception(
          'Could not connect to the server. Check your internet connection.',
        );
      }
      throw Exception(error.message ?? 'Unable to load the home screen.');
    } on FormatException catch (error) {
      throw Exception('Invalid API response: ${error.message}');
    }
  }
}
