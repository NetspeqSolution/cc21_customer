import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cc21_customer/models/account/change_password_model.dart';
import 'package:cc21_customer/models/account/customer_register_model.dart';
import 'package:cc21_customer/models/account/user_profile_model.dart';

import '../helpers/constants.dart';
import '../helpers/preference_manager.dart';
import '../models/account/login_model.dart';
import 'helpers/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'helpers/rest.dart';

final getIt = GetIt.instance;

class AccountService {
  String mainURL = RestAPI.getBaseURL();
  String baseURL = '/api/Account/';
  final networkHelper = getIt.get<NetworkHelper>();

  Future<dynamic> loginUser(String? userName, String? password) async {
    try {
      Map<String, String?> params = {
        'UserName': userName,
        'Password': password,
        'grant_type': 'password',
      };

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, '/token');
      } else {
        uri = Uri.https(mainURL, '/token');
      }

      var response = await http.post(uri,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: params);

      if (response.statusCode != 200) {
        if (response.body != null) {
          if (response.body is String) {
            if(response.body.toLowerCase().contains('invalid_grant'))
              return "Error: Please check your email and/or password";
            if(response.body.toLowerCase().contains('disabled'))
              return "Error: Your account has been disabled by the admin";
            if(response.body.toLowerCase().contains('not_verified'))
              return "Error: Sorry, you must have a confirmed credential to log in";
          }
        }
      } else {
        if (response.body != null) {
          return LoginModel.fromJson(jsonDecode(response.body), 'success');
        }
      }
      return "Error: There was some problem logging you in.";
    } on TimeoutException catch (e) {
      return kInternetError;
    } on SocketException catch (e) {
      return kInternetError;
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<String> registerRestaurant(CustomerRegisterModel model) async {
    Map<String, dynamic> bodyParameters = model.toJson();

    var uri;
    if (kUriScheme.compareTo('http') == 0) {
      uri = Uri.http(mainURL, '/api/Account/CustomerRegister');
    } else {
      uri = Uri.https(mainURL, '/api/Account/CustomerRegister');
    }

    return await networkHelper.postData(uri, bodyParameters);
  }

  Future<dynamic> getUserProfile(String userID) async {
    try {

      Map<String, String> queryParameters = {
        'Id': userID,
      };

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/Account/UserProfileByID', queryParameters);
      } else {
        uri = Uri.https(mainURL, 'api/Account/UserProfileByID', queryParameters);
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      } else {
        return UserProfileModel.fromJson(response);
      }
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<String> changePassword(ChangePasswordModel model) async {
    Map<String, dynamic> bodyParameters = model.toJson();

    var uri;
    if (kUriScheme.compareTo('http') == 0) {
      uri = Uri.http(mainURL, '/api/Account/ChangePassword');
    } else {
      uri = Uri.https(mainURL, '/api/Account/ChangePassword');
    }

    return await networkHelper.postData(uri, bodyParameters);
  }
}
