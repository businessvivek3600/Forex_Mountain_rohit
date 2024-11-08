import 'package:dio/dio.dart';
import 'package:forex_mountain/utils/my_logger.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.extra.addAll({'response_time': DateTime.now()});
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    logger.f(
      'onResponse:',
      tag:
          '${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path} ${calculateResponseTime(response.requestOptions.extra['response_time'])} ms',
      // error: response.data.toString(),
    );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e('onError:',
        tag:
            '${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.path} ${calculateResponseTime(err.requestOptions.extra['response_time'])} ms',
        error: err.error);
    return super.onError(err, handler);
  }

  int calculateResponseTime(DateTime startTime) {
    final endTime = DateTime.now();
    return endTime.difference(startTime).inMilliseconds;
  }
}
