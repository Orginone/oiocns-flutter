import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:orginone/utils/index.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../index.dart';

class HttpService extends GetxService {
  static HttpService get to => Get.find();

  late final Dio _dio;
  // final CancelToken _cancelToken = CancelToken(); // 默认去掉

  @override
  void onInit() {
    super.onInit();

    // 初始 dio
    var options = BaseOptions(
      baseUrl: RequestConfig.baseUrl,
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
      ..add(RequestInterceptors())
      ..add(prettyDioLogger);
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    // LogUtil.d(params);
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );

    // LogUtils.d('response: ${json.encode(response.data)}');
    // LogUtil.d('response: ${json.encode(response.data)}');

    return response;
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    // LogUtil.d('params: $data');
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );

    // LogUtil.d('response: ${json.encode(response.data)}');
    return response;
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    // LogUtil.d('params: $data');
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );

    // LogUtil.d('response: ${response.data}');
    return response;
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    // LogUtil.d('params: $data');
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    // LogUtil.d('response: ${response.data}');
    return response;
  }
}

/// 拦截
class RequestInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // super.onRequest(options, handler);
    if (UserService.to.hasToken) {
      // options.headers['Authorization'] = 'Bearer ${UserService.to.token}';
      options.headers[Constants.appTokenKey] = UserService.to.token;
    }
    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 200 请求成功, 201 添加成功

    if (response.statusCode == 200 && response.data["status"] == 2000) {
      //请求成功
      var res = response.data;
      if (response.data is Map) {
        //后端对返回数据 再response.data里面包了 data status message
        if ((res as Map).containsKey("data")) {
          response.data = res["data"];
          response.statusCode = res["status"];
          response.statusMessage = res["message"];
        }
      }

      handler.next(response);
    } else {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    }
    // if (response.statusCode != 200 &&
    //     response.statusCode != 201 &&
    //     response.data["status"] != 2000) {
    //   handler.reject(
    //     DioError(
    //       requestOptions: response.requestOptions,
    //       response: response,
    //       type: DioErrorType.response,
    //     ),
    //     true,
    //   );
    // } else {
    //   var res = response.data;
    //   if (response.data is Map) {
    //     //后端对返回数据 再response.data里面包了 data status message
    //     if ((res as Map).containsKey("data")) {
    //       response.data = res["data"];
    //       response.statusCode = res["status"];
    //       response.statusMessage = res["message"];
    //     }
    //   }

    //   handler.next(response);
    // }
  }

  @override
  Future<void> onError(
      DioException dioException, ErrorInterceptorHandler handler) async {
    // final httpException = HttpException(dioException.message??'未知错误');
    switch (dioException.type) {
      case DioExceptionType.badResponse: // 服务端自定义错误体处理
        {
          final response = dioException.response;
          final errorMessage = (response?.data is Map)
              ? ErrorMessageModel.fromJson(response?.data)
              : ErrorMessageModel(
                  statusCode: response?.statusCode,
                  error: dioException.error.toString(),
                  message: dioException.message);
          switch (errorMessage.statusCode) {
            case 401:
            case 2942:
              errorMessage.message = '登录已过期，请重新登录';
              _errorNoAuthLogout();
              break;
            case 404:
              break;
            case 500:
              break;
            case 502:
              break;
            default:
              break;
          }
          Loading.error(errorMessage.message);
        }
        break;
      case DioExceptionType.unknown:
        Loading.error(dioException.error.toString());
        break;
      case DioExceptionType.cancel:
        Loading.error("请求取消");
        break;
      case DioExceptionType.connectionTimeout:
        Loading.error("响应超时...");
        break;
      default:
        Loading.error(dioException.error == null
            ? dioException.message.toString()
            : dioException.error.toString());
        break;
    }

    // dioException.error = httpException;
    //异常统一处理之后继续让错误传递 再接口调用端可以自定义处理业务
    handler.next(dioException);
  }

  // 退出并重新登录
  Future<void> _errorNoAuthLogout() async {
    await UserService.to.logout();
    // Get.toNamed(RouteNames.systemLoginSafe);
  }
}
