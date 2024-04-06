import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../helpers/constants.dart';
import '../../helpers/preference_manager.dart';

class NetworkHelper {
  NetworkHelper(this.dio);

  final Dio dio;
  Map<String, String> headers = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  Future postData(Uri url, Map<String, dynamic> bodySet) async {
    String jsonEncodedBody = jsonEncode(bodySet);
    try {
      var response = await dio.requestUri(url,
          data: jsonEncodedBody,
          options: Options(method: 'POST', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future postEmptyData(Uri url) async {
    try {
      var response = await dio.requestUri(
        url,
        options: Options(method: 'POST', headers: headers),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future postEmptyDataWithoutDecoding(Uri url) async {
    try {
      var response = await dio.requestUri(url,
          options: Options(method: 'POST', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future postDataWithHeaders(Uri url, Map<String, dynamic> bodySet, String accessToken) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    };
    try {
      String jsonEncodedBody = jsonEncode(bodySet);
      var response = await dio.requestUri(url,
          data: jsonEncodedBody,
          options: Options(method: 'POST', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future postDataWithQueryString(
      Uri url, String userID, String accessToken) async {
    userID = PreferenceManager.getUserID();
    accessToken = PreferenceManager.getAccessToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    };
    try {
      var response = await dio.requestUri(url,
          options: Options(method: 'POST', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future getDataWithHeaders(var url, String accessToken) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await dio.requestUri(url,
          options: Options(method: 'GET', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future getData(Uri url) async {
    try {
      var response = await dio.requestUri(url,
          options: Options(method: 'GET', headers: headers));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }

  Future deleteDataWithHeaders(Uri url, Map<String, dynamic> bodySet,
      String userID, String accessToken) async {
    userID = PreferenceManager.getUserID();
    accessToken = PreferenceManager.getAccessToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    };
    try {
      var response = await dio.requestUri(url,
          options: Options(method: 'GET', headers: headers),
          data: jsonEncode(bodySet));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return kGeneralError;
      }
    } catch (exception) {
      return kGeneralError;
    }
  }
}
