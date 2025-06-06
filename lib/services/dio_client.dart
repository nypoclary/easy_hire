import 'package:dio/dio.dart';

class DioClient {
  static DioClient? _instance;
  Dio? _dio;
  bool _isInitialized = false;

  static const String _baseUrl = 'http://10.0.2.2:3000/api/v1';

  DioClient._internal();

  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio {
    if (_dio == null) {
      throw Exception('DioClient not initialized. Call initialize() first.');
    }
    return _dio!;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _addInterceptors();
    _isInitialized = true;
  }

  Future<void> reset() async {
    _dio?.close();
    _dio = null;
    _isInitialized = false;
    await initialize();
  }

  void _addInterceptors() {
    if (_dio == null) return;

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException error, handler) {
          final customError = _handleError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: customError,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    required String photoUrl,
    required String aboutMe,
  }) async {
    try {
      await dio.post(
        '/users',
        data: {
          'id': userId,
          'name': name,
          'email': email,
          'photoUrl': photoUrl,
          'aboutMe': aboutMe,
        },
      );
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String photoUrl,
    required String aboutMe,
  }) async {
    try {
      await dio.put(
        '/users/$userId',
        data: {
          'name': name,
          'email': email,
          'photoUrl': photoUrl,
          'aboutMe': aboutMe,
        },
      );
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<void> createJob(Map<String, dynamic> jobData) async {
    try {
      await dio.post('/jobs', data: jobData);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  static String get baseUrl => _baseUrl;

  static String get wsUrl => _baseUrl
      .replaceFirst('http://', 'ws://')
      .replaceFirst('/api/v1', '/ws/v1');

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      switch (statusCode) {
        case 400:
          return BadRequestException(data['message'] ?? 'Bad request');
        case 401:
          return UnauthorizedException(data['message'] ?? 'Unauthorized');
        case 403:
          return ForbiddenException(data['message'] ?? 'Forbidden');
        case 404:
          return NotFoundException(data['message'] ?? 'Not found');
        case 422:
          return ValidationException(data);
        case 500:
          return ServerException(data['message'] ?? 'Internal server error');
        default:
          return ApiException('Server error: $statusCode - $data');
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return ConnectionTimeoutException('Connection timeout');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return ReceiveTimeoutException('Receive timeout');
    } else if (error.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    } else {
      return ApiException('Unknown error: ${error.message}');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;
  ValidationException(dynamic data)
      : errors = data is Map<String, dynamic> ? data['errors'] : null,
        super(
          data is Map<String, dynamic>
              ? (data['message'] ?? 'Validation error')
              : 'Validation error',
        );
}

class ServerException extends ApiException {
  ServerException(super.message);
}

class ConnectionTimeoutException extends ApiException {
  ConnectionTimeoutException(super.message);
}

class ReceiveTimeoutException extends ApiException {
  ReceiveTimeoutException(super.message);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}
