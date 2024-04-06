import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../helpers/preference_manager.dart';

class DioConnectivityRequestRetry {
  final Dio dio;
  //final Connectivity connectivity;

  DioConnectivityRequestRetry({
    required this.dio,
    //required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    late StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();
    String accessToken = PreferenceManager.getAccessToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    // streamSubscription = connectivity.onConnectivityChanged.listen(
    //   (ConnectivityResult result) async {
    //     if (result != ConnectivityResult.none) {
    //       streamSubscription.cancel();
    //       responseCompleter.complete(
    //         dio.request(
    //           requestOptions.path,
    //           cancelToken: requestOptions.cancelToken,
    //           data: requestOptions.data,
    //           onReceiveProgress: requestOptions.onReceiveProgress,
    //           onSendProgress: requestOptions.onSendProgress,
    //           queryParameters: requestOptions.queryParameters,
    //           options: Options(
    //               method: requestOptions.method,
    //               headers: headers,
    //               contentType: requestOptions.contentType,
    //               extra: requestOptions.extra,
    //               listFormat: requestOptions.listFormat),
    //         ),
    //       );
    //     }
      //},
    //);
    return responseCompleter.future;
  }
}
