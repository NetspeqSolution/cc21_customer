import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cc21_customer/models/home/restaurant_dtls_with_timeslots_view_api_vm.dart';
import 'package:cc21_customer/services/utbl_mst_restaurant_operation_type.dart';

import '../helpers/constants.dart';
import '../helpers/preference_manager.dart';
import '../models/account/login_model.dart';
import '../models/home/b_category_dd.dart';
import '../models/home/utbl_mst_restaurant_cuisine_type.dart';
import '../models/home/utbl_mst_restaurant_ownership_type.dart';
import 'helpers/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'helpers/rest.dart';

final getIt = GetIt.instance;

class HomeService {
  String mainURL = RestAPI.getBaseURL();
  String baseURL = '';
  final networkHelper = getIt.get<NetworkHelper>();

  Future<dynamic> getRestaurantOperationTypes() async {
    try {

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/MasterConfig/Master/GetRestaurantOperationTypes');
      } else {
        uri = Uri.https(mainURL, 'api/MasterConfig/Master/GetRestaurantOperationTypes');
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      }
      else {
        return List<UtblMstRestaurantOperationType>.from(
            response.map((e) => UtblMstRestaurantOperationType.fromJson(e)));
      }
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<dynamic> getBizCategories() async {
    try {

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/MasterConfig/Master/GetBCategoryDD');
      } else {
        uri = Uri.https(mainURL, 'api/MasterConfig/Master/GetBCategoryDD');
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      } else {
        return List<BCategoryDd>.from(
            response.map((e) => BCategoryDd.fromJson(e)));
      }
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<dynamic> getRestaurantOwnershipTypes() async {
    try {

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/MasterConfig/Master/GetRestaurantOwnershipTypes');
      } else {
        uri = Uri.https(mainURL, 'api/MasterConfig/Master/GetRestaurantOwnershipTypes');
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      } else {
        return List<UtblMstRestaurantOwnershipType>.from(
            response.map((e) => UtblMstRestaurantOwnershipType.fromJson(e)));
      }
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<dynamic> getRestaurantCuisineTypes() async {
    try {

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/MasterConfig/Master/GetRestaurantCuisineTypes');
      } else {
        uri = Uri.https(mainURL, 'api/MasterConfig/Master/GetRestaurantCuisineTypes');
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      } else {
        return List<UtblMstRestaurantCuisineType>.from(
            response.map((e) => UtblMstRestaurantCuisineType.fromJson(e)));
      }
    } catch (e) {
      return kGeneralError;
    }
  }

  Future<dynamic> getRestaurants(String? bizID, String? operationTypeID, String? ownershipTypeID, String? cuisineTypeID,
      int pageNo, int pageSize, String searchTerm, String lat, String lng) async {
    try {

      Map<String, String> queryParameters = {
        'BizID': bizID??"",
        'OperationTypeID': operationTypeID??"",
        'OwnershipTypeID':ownershipTypeID??"",
        'CuisineTypeID':cuisineTypeID??"",
        'PageNo':jsonEncode(pageNo),
        'PageSize':jsonEncode(pageSize),
        'SearchTerm':searchTerm,
        'Lat':lat,
        'Lng':lng
      };

      var uri;
      if (kUriScheme.compareTo('http') == 0) {
        uri = Uri.http(mainURL, 'api/General/Home/GetPartnersPagedWithFilters',queryParameters);
      } else {
        uri = Uri.https(mainURL, 'api/General/Home/GetPartnersPagedWithFilters',queryParameters);
      }

      var response = await networkHelper.getDataWithHeaders(
          uri, PreferenceManager.getAccessToken());

      if(response is String){
        return response;
      } else {
        return RestaurantDtlsWithTimeSlotsViewApivm.fromJson(response);
      }
    } catch (e) {
      return kGeneralError;
    }
  }
}
