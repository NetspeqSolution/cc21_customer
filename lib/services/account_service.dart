import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cc21_customer/models/customer_register_model.dart';

import '../helpers/constants.dart';
import '../models/login_model.dart';
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
}
