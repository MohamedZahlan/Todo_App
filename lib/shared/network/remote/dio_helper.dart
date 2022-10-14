import 'package:dio/dio.dart';

class Dio_Helper {
  static Dio dio = Dio();

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          headers: {"Content-Type": "application/json"},
          receiveDataWhenStatusError: true),
    );
  }

  static Future<Response> getData({
    required String url,
    query,
    String? token,
    String lang = 'en',
    int? productID,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required data,
    query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    required data,
    query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.put(url, data: data, queryParameters: query);
  }
}
