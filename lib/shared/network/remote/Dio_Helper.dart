import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper{
  static Dio dio;
  static init()
  {
    dio = new Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
        )
    );
  }

  static Future<Response> GetData ({
    @required String url,
    Map<String, dynamic> queries,
    String lang = 'en',
    String token,
  })async {

    dio.options.headers =
    {
      'Content-Type':'application/json',
      'lang' : lang,
      'Authorization' : token,
    };

    return await dio.get
      (
      url,
      queryParameters: queries,
    );
  }

  static Future<Response> PostData({
    @required String url,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers =
    {
      'Content-Type':'application/json',
      'lang' : lang,
      'Authorization' : token,
    };

    return await dio.post(
      url,
      data: data,
    );
  }

  static Future<Response> PutData({
    @required String url,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers =
    {
      'Content-Type':'application/json',
      'lang' : lang,
      'Authorization' : token,
    };

    return await dio.put(
      url,
      data: data,
    );
  }
}