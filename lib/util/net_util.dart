import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

import '../model/index.dart';

class NetUtils {
  static final String baseUrl = 'http://ppodd.cn:3030';

  static Future<Response> _get(
    String url, {
    Map<String, dynamic> params,
    bool isShowLoading = true,
  }) async {
    try {
      Dio dio = new Dio();
      return await dio.post(url, data: params);
    } on DioError catch (e) {
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response != null) {
        if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
          return Future.error(Response(data: -1));
        } else {
          return Future.value(e.response);
        }
      } else {
        return Future.error(Response(data: -1));
      }
    }
  }

  static String getRequestUrl (String url, dynamic param) {
    String key = 'H7843HOIDSHF9I23897V';
    var format = new DateFormat('yyyy-MM-dd,HH:mm:ss');
    String timestamp = format.format(new DateTime.now());
    String str = "$url-$key-$timestamp?";
    if(param is Map){
      if(param.keys.length > 0){
        List keySort = new List.from(param.keys);
        keySort.sort();
        for(var item in keySort){
          if (item.endsWith('_noSign')) continue;
          str += param[item];
        }
      }
    }
    String sign = _generateMd5(str).toUpperCase();
    return "$baseUrl$url?t=$timestamp&sign=$sign";
  }

  static String _generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }


  // 车辆识别
  static Future<CarInfo> getCarInfo(FormData params) async {
    String requestUrl = getRequestUrl('/api/tencent/carinfo', params);
    var response = await _get(requestUrl, params: params);
    return CarInfo.fromJson(response.data['result']['body']);
  }
}