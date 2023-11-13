import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'storage.dart';

class HttpUtil {
  HttpUtil._();

  static final HttpUtil _instance = HttpUtil._();
  late final Dio _dio;
  factory HttpUtil() {
    return _instance;
  }

  Logger log = Logger("HttpLogger");
  var dio = Dio(BaseOptions(
    baseUrl: Constant.host,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  void init() {
    // 初始 dio
    var options = BaseOptions(
      baseUrl: Constant.host,
      connectTimeout: const Duration(seconds: 5), // 5秒
      receiveTimeout: const Duration(seconds: 5), // 5秒
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    var prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    );
    _dio = Dio(options);
    // 拦截器
    _dio.interceptors
      ..add(prettyDioLogger)
      ..add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioException e, handler) {
        return handler.next(e);
      }));
  }

  Future<Options> addTokenHeader(Options? options) async {
    var accessToken = Storage().getString('accessToken');
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

      return result.data!;
    } on DioException catch (error) {
      _onDioError(error, showError!);
      // rethrow;
    } on Exception catch (error) {
      _onExceptionError(error, showError!);
      // rethrow;
    } finally {
      log.info("================End Get Http Request================");
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool? hasToken,
    bool? showError = true,
  }) async {
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

      return result.data!;
    } on DioException catch (error) {
      _onDioError(error, showError!);
      // rethrow;
    } on Exception catch (error) {
      _onExceptionError(error, showError!);
      // rethrow;
    } finally {
      log.info("================End Post Http Request================");
    }
  }

  _onExceptionError(Exception error, bool showToast) {
    log.info("errorInfo =====> ${error.toString()}");
    if (showToast) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  _onDioError(DioException error, bool showToast) {
    if (error.response == null) return;
    Response response = error.response!;
    var statusCode = response.statusCode;
    if (statusCode == 400 || statusCode == 500) {
      log.info("errorInfo =====> ${response.statusMessage}");
      if (showToast) {
        Fluttertoast.showToast(msg: response.statusMessage ?? "");
      }
    } else if (statusCode == 401) {
      ToastUtils.showMsg(msg: "登录已过期,请重新登录");
      //token过期
      _errorNoAuthLogout();
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

  // 退出并重新登录
  Future<void> _errorNoAuthLogout() async {
    settingCtrl.exitLogin(cleanUserLoginInfo: false);
  }
}
