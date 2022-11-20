import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/util/api_exception.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api_resp/api_resp.dart';
import '../config/constant.dart';
import 'api_exception.dart';

class HttpUtil {
  HttpUtil._();

  static final HttpUtil _instance = HttpUtil._();

  factory HttpUtil() {
    return _instance;
  }

  Logger log = Logger("HttpLogger");
  var dio = Dio(BaseOptions(
    baseUrl: Constant.host,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  ));

  void init() {
    dio
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        return handler.next(e);
      }));
  }

  Future<Options> addTokenHeader(Options? options) async {
    var accessToken = getAccessToken;
    log.info("====> accessToken：$accessToken");
    if (options == null) {
      return Options(headers: {"Authorization": accessToken});
    } else {
      if (options.headers == null) {
        options.headers = {"Authorization": accessToken};
      } else {
        options.headers!["Authorization"] = accessToken;
      }
    }
    return options;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool? hasToken,
    bool? showError = true,
  }) async {
    log.info("================Get Http Request================");
    try {
      log.info("====> path: $path");
      log.info("====> queryParameters: ${queryParameters.toString()}");

      if (hasToken ?? true) {
        options = await addTokenHeader(options);
      }

      Response result = await dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      return _parseResp(result);
    } on ApiException catch (error) {
      if (showError!) {
        Fluttertoast.showToast(msg: error.message);
      }
      rethrow;
    } on DioError catch (error) {
      if (showError!) {
        Fluttertoast.showToast(msg: error.message);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "请求异常,请联系管理员处理!");
      rethrow;
    } finally {
      log.info("================End Get Http Request================");
    }
  }

  Future<dynamic> post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool? hasToken,
      bool? showError = true}) async {
    log.info("================Post Http Request================");
    try {
      log.info("====> path: $path");
      log.info("====> queryParameters: ${queryParameters.toString()}");
      log.info("====> data: ${data.toString()}");

      if (hasToken ?? true) {
        options = await addTokenHeader(options);
      }

      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _parseResp(result);
    } on ApiException catch (error) {
      if (showError!) {
        Fluttertoast.showToast(msg: error.message);
      }
      rethrow;
    } on DioError catch (error) {
      if (showError!) {
        Fluttertoast.showToast(msg: error.message);
      }
      rethrow;
    } catch (error) {
      Fluttertoast.showToast(msg: "请求异常,请联系管理员处理!");
      rethrow;
    } finally {
      log.info("================End Post Http Request================");
    }
  }

  dynamic _parseResp(Response response) {
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    } else {
      log.info(response.data!);
      var resp = ApiResp.fromJson(response.data!);
      if (resp.code == 200) {
        return resp.data;
      }
      throw ApiException(resp.msg);
    }
  }

  Future<dynamic> download({
    required String url,
    required String savePath,
    required Function progressCallback,
  }) async {
    dio.download(url, savePath, onReceiveProgress: (received, total) {
      progressCallback(received, total);
    });
  }
}
