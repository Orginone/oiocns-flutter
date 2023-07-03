import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpUtil {
  HttpUtil._();

  static final HttpUtil _instance = HttpUtil._();

  factory HttpUtil() {
    return _instance;
  }

  Logger log = Logger("HttpLogger");
  var dio = Dio(BaseOptions(
    baseUrl: Constant.host,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
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
    var accessToken = "getAccessToken";
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
    } on DioError catch (error) {
      _onDioError(error, showError!);
    } on Exception catch (error) {
      _onExceptionError(error, showError!);
      rethrow;
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
    } on DioError catch (error) {
      _onDioError(error, showError!);
      rethrow;
    } on Exception catch (error) {
      _onExceptionError(error, showError!);
      rethrow;
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

  _onDioError(DioError error, bool showToast) {
    if (error.response == null) return;
    Response response = error.response!;
    var statusCode = response.statusCode;
    if (statusCode == 400 || statusCode == 500) {
      log.info("errorInfo =====> ${response.statusMessage}");
      if (showToast) {
        Fluttertoast.showToast(msg: response.statusMessage ?? "");
      }
    } else if (statusCode == 401) {}
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
