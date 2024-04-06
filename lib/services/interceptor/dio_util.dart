import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../helpers/constants.dart';
import '../../helpers/preference_manager.dart';
import '../helpers/rest.dart';


class DioUtil {
  var _instance = null;
  String userID = '';
  Uri url = Uri();
  String type = '';
  Map<String, dynamic> bodySet = {};
  static const String APP_SECRET = "Medhelp@Secret2021";

  Dio getInstance() {
    if (_instance == null) {
      _instance = createDioInstance();
    }
    return _instance;
  }

  Future<String> getAccessFromRefreshToken() async {
    Map<String, String> params = {
    'accessToken': PreferenceManager.getAccessToken(),
    'refreshToken': PreferenceManager.getRefreshToken(),
  };
    try {

    var uriNew =
    Uri(scheme: kUriScheme, host: khost, port: kport, path: '/api/Authenticate/refresh-token');

    var response = await http.post(
    uriNew,
    headers: {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    },
    body: params,
    );

    if (response.statusCode != 200) {
    return 'error';
    } else if(response.body!=null) {
    // If everything is fine, add the new details to the preference manager

    // await PreferenceManager.setUserID(details.userId);
    // await PreferenceManager.setUserName(details.profileName);
    // await PreferenceManager.setUserEmail(details.email);
    // //await PreferenceManager.setUserRole(details.role);
    // await PreferenceManager.setAccessToken(details.accessToken);
    // await PreferenceManager.setRefreshToken(details.refreshToken);
    // await PreferenceManager.setUserName(details.userName);
    // await preferenceManager.setUserLoggedOut(false);
    return 'success';
    }
    return 'error';
    } catch (exception) {
    return 'Please check your internet connection';
    }
  }

  String createAuthenticationHeader(String userID) {
    String authorizationValue = '$userID:$APP_SECRET';
    return base64Encode(utf8.encode(authorizationValue));
  }

  Future requestForAccessToken(RequestOptions origin, Dio dio) async {
    String responseString = await getAccessFromRefreshToken();
    if (responseString == 'success') {
      userID = PreferenceManager.getUserID();
      String accessToken = PreferenceManager.getAccessToken();

      var response;
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      response = dio.request(origin.path,
          cancelToken: origin.cancelToken,
          data: origin.data,
          onReceiveProgress: origin.onReceiveProgress,
          onSendProgress: origin.onSendProgress,
          queryParameters: origin.queryParameters,
          options: Options(
              method: origin.method,
              headers: headers,
              contentType: origin.contentType,
              extra: origin.extra,
              listFormat: origin.listFormat));
      return response;
    } else {
      // The user is not logged in.
      return 'Error: You have been logged out of ' + kAppName;
    }
  }

  Dio createDioInstance() {
    var dio = Dio();
    // DioConnectivityRequestRetry connectivity =
    //     DioConnectivityRequestRetry(dio: dio, connectivity: Connectivity());
    dio.interceptors.clear();
    dio.interceptors
        .add(QueuedInterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options); //modify your request
    }, onResponse: (response, handler) {
      if (response != null) {
        //on success it is getting called here
        return handler.next(response);
      } else {
        return null;
      }
    }, onError: (DioError e, handler) async {
      RequestOptions origin = e.requestOptions;
      if (e.error is SocketException) {
        // final response =
        //     await connectivity.scheduleRequestRetry(e.requestOptions);
        // handler.resolve(response);
      } else if (errorType(e)) {
        print('Inside 401');
        final response = await requestForAccessToken(origin, dio);

        if (response != null) {
          print('aayo naya');

          handler.resolve(response);
        } else {
          dio.interceptors.clear();
          return null;
        }
      } else {
        handler.next(e);
      }
    }));
    return dio;
  }

  bool errorType(error) {
    return error != null && error.response.statusCode == 401;
  }
}
