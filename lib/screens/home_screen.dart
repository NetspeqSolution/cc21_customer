import 'dart:async';

import 'package:cc21_customer/helpers/constants.dart';
import 'package:cc21_customer/helpers/preference_manager.dart';
import 'package:cc21_customer/helpers/size_config.dart';
import 'package:cc21_customer/models/account/user_profile_model.dart';
import 'package:cc21_customer/screens/account/change_password_screen.dart';
import 'package:cc21_customer/screens/account/login_screen.dart';
import 'package:cc21_customer/screens/cart/cart_screen.dart';
import 'package:cc21_customer/screens/notification/notification_screen.dart';
import 'package:cc21_customer/screens/orders/order_screen.dart';
import 'package:cc21_customer/screens/home_screen.dart';
import 'package:cc21_customer/services/account_service.dart';
import 'package:cc21_customer/services/home_service.dart';
import 'package:flutter/material.dart';
import '../helpers/image_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../helpers/location_service.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/home/b_category_dd.dart';
import '../models/home/restaurant_dtls_with_timeslots_view_api_vm.dart';
import '../models/home/restaurant_filter_list_model.dart';
import '../models/home/utbl_mst_restaurant_cuisine_type.dart';
import '../models/home/utbl_mst_restaurant_ownership_type.dart';
import '../services/utbl_mst_restaurant_operation_type.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String profileImage = "", deliveryAddress = "";
  late Position currentPos;
  TextEditingController locationController = new TextEditingController();
  String? selectedLocation, selectedLocationLat, selectedLocationLng;
  int _addressMaxLines = 1;
  bool showProgressBar = true;
  late TextEditingController searchController;

  List<UtblMstRestaurantOperationType> operationTypes = [];
  List<UtblMstRestaurantCuisineType> cuisineTypes = [];
  String? selectedOperationType = null, selectedCuisineType = null;
  HomeService homeService = new HomeService();
  AccountService accountService = new AccountService();
  int _selectedOperationTypeIndex = 0;
  int _selectedCuisineTypeIndex = 1;
  List<PartnerList> partnerList = [];
  bool _hasMore = true, _isLoading = false;
  int pageSize = 4;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    getLocation().then((value) {
      fetchUserProfile();
      fetchDDList().then((value) {
        fetchRestaurantList();
        setState(() {
          showProgressBar = false;
        });
      });
    });
  }

  void onSearchChange() async {
    setState(() {
      showProgressBar = true;
    });
    await fetchRestaurantList();
  }

  Future<void> getCurrentLocation() async {
    bool permissionAvailable = await checkIfAllowedN();
    if (permissionAvailable) {
      currentPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPos.latitude, currentPos.longitude);
      selectedLocationLat = currentPos.latitude.toString();
      selectedLocationLng = currentPos.longitude.toString();
      PreferenceManager.setDeliveryLat(selectedLocationLat ?? "");
      PreferenceManager.setDeliveryLng(selectedLocationLng ?? "");

      setState(() {
        deliveryAddress = placemarks.first.street.toString() +
            ", " +
            placemarks.first.locality.toString();
        locationController.text = deliveryAddress;
        selectedLocation = deliveryAddress;
      });

      PreferenceManager.setDeliveryAddress(deliveryAddress);

      return;
    }
  }

  Future<void> getLocation() async {
    await PreferenceManager.init();
    String prefAddress = await PreferenceManager.getDeliveryAddress();
    if (prefAddress.isEmpty) {
      await getCurrentLocation();
    } else {
      selectedLocationLat = await PreferenceManager.getDeliveryLat();
      selectedLocationLng = await PreferenceManager.getDeliveryLng();
      selectedLocation = await PreferenceManager.getDeliveryAddress();

      setState(() {
        locationController.text = selectedLocation!;
        deliveryAddress = selectedLocation!;
      });
    }
  }

  bool validateSelectedLocation() {
    if (selectedLocation != null && locationController.text != null) {
      if (locationController.text == selectedLocation &&
          selectedLocation!.isNotEmpty &&
          locationController.text!.isNotEmpty) {
        setState(() {
          deliveryAddress = selectedLocation ?? "";
        });
        PreferenceManager.setDeliveryLat(selectedLocationLat ?? "");
        PreferenceManager.setDeliveryLng(selectedLocationLng ?? "");
        PreferenceManager.setDeliveryAddress(deliveryAddress);

        return true;
      }
    }

    Fluttertoast.showToast(
        msg: "Please select a valid location from the dropdown.");
    return false;
  }

  Future<void> fetchUserProfile() async {
    await PreferenceManager.init();
    var response = await accountService
        .getUserProfile(await PreferenceManager.getUserID());
    if (response is String) {
      Fluttertoast.showToast(msg: response);
    } else {
      UserProfileModel model = response;
      setState(() {
        profileImage = model.userImage;
      });
    }
  }

  Future<void> fetchDDList() async {
    await PreferenceManager.init();
    var response1 = await homeService.getRestaurantOperationTypes();

    if (response1 is String) {
      Fluttertoast.showToast(msg: response1);
    } else {
      setState(() {
        operationTypes = response1;
        UtblMstRestaurantOperationType allOprerationType =
            new UtblMstRestaurantOperationType(
                operationTypeId: 0, operationTypeName: "All");
        operationTypes.insert(0, allOprerationType);
        // UtblMstRestaurantOperationType localOprerationType =
        //     new UtblMstRestaurantOperationType(
        //         operationTypeId: -1, operationTypeName: "Local Restaurants");
        // operationTypes.add(localOprerationType);
      });
    }

    var response2 = await homeService.getRestaurantCuisineTypes();

    if (response2 is String) {
      Fluttertoast.showToast(msg: response2);
    } else {
      setState(() {
        cuisineTypes = response2;
        UtblMstRestaurantCuisineType allCuisine =
            new UtblMstRestaurantCuisineType(cuisineId: 0, cuisineName: "All");
        UtblMstRestaurantCuisineType filter = new UtblMstRestaurantCuisineType(
            cuisineId: -1, cuisineName: "Filter");
        cuisineTypes.insert(0, filter);
        cuisineTypes.insert(1, allCuisine);
      });
    }
  }

  Future<void> fetchRestaurantList({int pageNo = 1}) async {
    try {
      if (pageNo == 1) partnerList = [];

      await PreferenceManager.init();
      String lat = await PreferenceManager.getDeliveryLng();
      String lng = await PreferenceManager.getDeliveryLat();
      String at = await PreferenceManager.getAccessToken();
      String operationType;
      if (operationTypes
              .elementAt(_selectedOperationTypeIndex)
              .operationTypeName
              .toLowerCase()
              .compareTo("all") ==
          0)
        operationType = "";
      else
        operationType = operationTypes
            .elementAt(_selectedOperationTypeIndex)
            .operationTypeName;

      String cuisineType;
      if (cuisineTypes
              .elementAt(_selectedCuisineTypeIndex)
              .cuisineName
              .toLowerCase()
              .compareTo("all") ==
          0)
        cuisineType = "";
      else
        cuisineType =
            cuisineTypes.elementAt(_selectedCuisineTypeIndex).cuisineName;

      if (!lat.isNotEmpty || lng.isNotEmpty) {
        var response = await homeService.getRestaurants("", operationType, "",
            cuisineType, pageNo, pageSize, searchController.text, lat, lng);

        if (response is String) {
          Fluttertoast.showToast(msg: response);
        } else {
          RestaurantDtlsWithTimeSlotsViewApivm model = response;

          setState(() {
            if (pageNo > 1)
              partnerList.addAll(model.partnerList);
            else
              partnerList = model.partnerList;
          });

          if (model.totalRecords > partnerList.length) {
            setState(() {
              _hasMore = true;
            });
          } else {
            setState(() {
              _hasMore = false;
            });
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:
                "Please choose your delivery address to check out restaurants.",
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          partnerList = [];
        });
      }

      setState(() {
        showProgressBar = false;
      });
    } catch (e) {
      setState(() {
        showProgressBar = false;
      });
      return null;
    }
  }

  String getRestaurantOperationalInfo(PartnerList model) {
    if (model.partner.todayIsClosed.toLowerCase().compareTo("no") != 0) {
      return "Closed Today";
    } else {
      int currentDay = DateTime.now().weekday;
      return model.restaurantTimeSlots.elementAt(currentDay).openingTime +
          " - " +
          model.restaurantTimeSlots.elementAt(currentDay).closingTime;
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.popAndPushNamed(context, CartScreen.routeName);
    } else if (index == 2) {
      Navigator.popAndPushNamed(context, NotificationScreen.routeName);
    } else if (index == 3) {
      Navigator.popAndPushNamed(context, OrderScreen.routeName);
    }
  }

  void selectCuisineFilter(int index) async {
    if (index == 0) {
      _modalBottomSheetMenu();
    } else {
      _selectedCuisineTypeIndex = index;

      setState(() {
        showProgressBar = true;
      });
      await fetchRestaurantList();
    }
  }

  Future<void> _loadMore({int pageNo = 2}) async {
    try {
      if (pageNo != 1) {
        _isLoading = true;

        await fetchRestaurantList(pageNo: pageNo);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      return null;
    }
  }

  void logout(BuildContext context) async {
    PreferenceManager.deleteUserBasicInfo();
    Navigator.popAndPushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(12),
                  horizontal: getProportionateScreenWidth(12)),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: Colors.white,
                            title: Text(
                              'Select Location',
                              style: kh2.copyWith(color: kPrimaryColor),
                            ),
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: getWidthForPercentage(80),
                                  maxHeight: getProportionateScreenHeight(120)),
                              child: Column(
                                children: [
                                  GooglePlaceAutoCompleteTextField(
                                    textEditingController: locationController,
                                    googleAPIKey: kPlacesApiKey,
                                    inputDecoration: InputDecoration(
                                      hintText: "Search your location",
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                    debounceTime: 400,
                                    countries: ["au"],
                                    isLatLngRequired: true,
                                    getPlaceDetailWithLatLng:
                                        (Prediction prediction) {
                                      selectedLocationLat =
                                          prediction.lat.toString();
                                      selectedLocationLng =
                                          prediction.lng.toString();
                                    },

                                    itemClick: (Prediction prediction) {
                                      locationController.text =
                                          prediction.description ?? "";
                                      locationController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: prediction.description
                                                          ?.length ??
                                                      0));
                                      selectedLocation =
                                          prediction.description ?? "";
                                    },
                                    seperatedBuilder: Divider(),
                                    containerHorizontalPadding: 10,

                                    // OPTIONAL// If you want to customize list view item builder
                                    itemBuilder: (context, index,
                                        Prediction prediction) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_on),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                                child: Text(
                                                    "${prediction.description ?? ""}"))
                                          ],
                                        ),
                                      );
                                    },

                                    isCrossBtnShown: true,

                                    // default 600 ms ,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(24),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        showProgressBar = true;
                                      });
                                      await getCurrentLocation();
                                      await fetchRestaurantList();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Select Current",
                                          style: kh4.copyWith(
                                              color: kPrimaryColor),
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          color: kPrimaryColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: kh4.copyWith(color: kPrimaryColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Select',
                                  style: kh4.copyWith(color: kPrimaryColor),
                                ),
                                onPressed: () async {
                                  if (validateSelectedLocation()) {
                                    Navigator.pop(context);
                                    setState(() {
                                      showProgressBar = true;
                                    });
                                    await fetchRestaurantList();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(children: [
                      Icon(
                        Icons.location_on,
                        color: kButtonSecondaryColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Delivery Address",
                              style:
                                  kh4.copyWith(color: kButtonSecondaryColor)),
                          Container(
                              width: getWidthForPercentage(40),
                              child: Text(
                                deliveryAddress,
                                style:
                                    kh4.copyWith(color: kButtonSecondaryColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: _addressMaxLines,
                              )),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_addressMaxLines == 1) {
                            setState(() {
                              _addressMaxLines = 2;
                            });
                          } else {
                            setState(() {
                              _addressMaxLines = 1;
                            });
                          }
                        },
                        child: Icon(
                          _addressMaxLines == 1
                              ? Icons.keyboard_arrow_down_outlined
                              : Icons.keyboard_arrow_up_outlined,
                          color: kWhite,
                        ),
                      ),
                    ]),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      showPopupMenu(context);
                    },
                    child: CircleAvatar(
                        radius: 20,
                        backgroundImage: profileImage.isEmpty
                            ? AssetImage('assets/images/user_img.png')
                            : imageProviderFromBase64String(profileImage)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(12),
                    vertical: getProportionateScreenHeight(12)),
                child: Column(
                  children: [
                    //     SvgPicture.asset(
                    //     "assets/images/damru_banner.svg",
                    //       width: getWidthForPercentage(100),
                    // ),
                    Image(
                        width: getWidthForPercentage(100),
                        image: AssetImage('assets/images/damru_banner.jpg')),
                    SizedBox(
                      height: getProportionateScreenHeight(12),
                    ),
                    TextField(
                      onChanged: (s) {
                        onSearchChange();
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.all(0),
                        fillColor: kSecondaryColor,
                        prefixIcon: Icon(
                          Icons.search,
                          color: kTextLight,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            searchController.clear();
                            onSearchChange();
                          },
                          child: Icon(
                            Icons.close_sharp,
                            color: kTextLight,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        hintText: 'Search your restaurant',
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(12),
                    ),
                    Container(
                      width: getWidthForPercentage(100),
                      child: CuisineFilterList(
                        filterList: cuisineTypes,
                        selectFilter: this.selectCuisineFilter,
                        selectedCuisineTypeIndex: _selectedCuisineTypeIndex,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Popular Restaurants",
                              style: kh1,
                            )),
                      ],
                    ),
                    if (showProgressBar)
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        ),
                      )
                    else if (partnerList.length == 0)
                      Expanded(
                        child: Center(
                          child: Text("No restaurants found."),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Container(
                              child: GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.78,
                                  children: List.generate(
                                      _hasMore
                                          ? partnerList.length + 1
                                          : partnerList.length, (index) {
                                    // child: ListView.separated(
                                    //     separatorBuilder: (BuildContext context,
                                    //         int index) {
                                    //       return Divider(height: 12.0,
                                    //           color: Colors.transparent);
                                    //     },
                                    //     physics: ScrollPhysics(),
                                    //     itemCount: _hasMore
                                    //         ? partnerList.length + 1
                                    //         : partnerList.length,
                                    //     itemBuilder: (BuildContext context,
                                    //         int index)   {

                                    if (index >= partnerList.length) {
                                      if (!_isLoading) {
                                        _loadMore(
                                            pageNo:
                                                (index / pageSize).floor() + 1);
                                      }
                                      return Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                          height: 24,
                                          width: 24,
                                        ),
                                      );
                                    }
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              getProportionateScreenHeight(8),
                                          horizontal:
                                              getProportionateScreenWidth(8)),
                                      decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              getProportionateScreenHeight(12),
                                          horizontal:
                                              getProportionateScreenWidth(8)),
                                      child: Column(
                                        children: [
                                          Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    120),
                                            width: getWidthForPercentage(100),
                                            child: Stack(children: [
                                              Image.network(
                                                kWebLiveUploadURL +
                                                    partnerList
                                                        .elementAt(index)
                                                        .partner
                                                        .imagesUpload,
                                                height:
                                                    getProportionateScreenHeight(
                                                        110),
                                                width:
                                                    getWidthForPercentage(100),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenWidth(
                                                              12)),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(
                                                        kWebLiveUploadURL +
                                                            partnerList
                                                                .elementAt(
                                                                    index)
                                                                .partner
                                                                .imagesUpload),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: partnerList
                                                                .elementAt(
                                                                    index)
                                                                .partner
                                                                .isActive
                                                            ? Colors.green
                                                            : Colors.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getProportionateScreenWidth(
                                                              8),
                                                      vertical:
                                                          getProportionateScreenHeight(
                                                              8),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getProportionateScreenWidth(
                                                              2),
                                                      vertical:
                                                          getProportionateScreenHeight(
                                                              2),
                                                    ),
                                                    child: Text(
                                                        partnerList
                                                                .elementAt(
                                                                    index)
                                                                .partner
                                                                .isActive
                                                            ? "open"
                                                            : "closed",
                                                        style: kh4.copyWith(
                                                            color: kWhite)),
                                                  ))
                                              // Align(
                                              //     alignment: Alignment.bottomLeft,
                                              //     child:  Image.network(
                                              //       kWebLiveUploadURL+partnerList.elementAt(index).partner.coverImage,
                                              //       height: getProportionateScreenHeight(20),
                                              //       width: getProportionateScreenWidth(20),
                                              //     ),)
                                            ]),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    12),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                partnerList
                                                    .elementAt(index)
                                                    .partner
                                                    .name,
                                                maxLines: 2,
                                                style: kh5.copyWith(
                                                    color: kBlack,
                                                    fontFamily: "NotoSansBold"),
                                              ),
                                              SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          8)),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            getProportionateScreenHeight(
                                                                2)),
                                                    child: Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      " " +
                                                          partnerList
                                                              .elementAt(index)
                                                              .partner
                                                              .address,
                                                      style: kh6,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                thickness: 0.1,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.timelapse_rounded,
                                                    color: Colors.green,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                    " " +
                                                        getRestaurantOperationalInfo(
                                                            partnerList
                                                                .elementAt(
                                                                    index)),
                                                    style: kh6,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }))),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: kPrimaryColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_outlined),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Orders',
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kButtonSecondaryColor,
            unselectedItemColor: kWhite,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return new Container(
              height: 350.0,
              color: Colors.transparent,
              //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Column(
                    children: [
                      Text(
                        "Filter",
                        style: kh2.copyWith(color: kPrimaryColor),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(12),
                      ),

                      //If its the last index of the lwidget list, append _AddElement under the _addresswidget
                      Container(
                        height: getProportionateScreenHeight(350),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              for (int i = 0; i < operationTypes.length; i++)
                                RadioListTile<int>(
                                  title: Text(operationTypes
                                      .elementAt(i)
                                      .operationTypeName),
                                  value: i,
                                  activeColor: Colors.red,
                                  groupValue: _selectedOperationTypeIndex,
                                  onChanged: (value) async {
                                    setModalState(() {
                                      _selectedOperationTypeIndex = value!;
                                    });
                                    await fetchRestaurantList();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  showPopupMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      surfaceTintColor: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: RelativeRect.fromLTRB(getProportionateScreenWidth(10),
          getProportionateScreenHeight(90), 0, 0),
      //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
            child: Text('Profile', style: kSecondaryTextStyle), value: '1'),
        PopupMenuItem<String>(
            onTap: () {
              Navigator.pushNamed(context, ChangePasswordScreen.routeName);
            },
            child: Text('Change Password', style: kSecondaryTextStyle),
            value: '2'),
        PopupMenuItem<String>(
            onTap: () {
              logout(context);
            },
            child: Text('Logout', style: kSecondaryTextStyle),
            value: '3'),
      ],
      elevation: 8.0,
    ).then<void>((String itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        //code here
      } else if (itemSelected == "2") {
        //code here
      } else {}
    } as FutureOr<void> Function(String? value));
  }
}

class CuisineFilterList extends StatelessWidget {
  const CuisineFilterList(
      {super.key,
      required List<UtblMstRestaurantCuisineType> this.filterList,
      required this.selectFilter,
      required this.selectedCuisineTypeIndex});

  final List<UtblMstRestaurantCuisineType> filterList;
  final Function(int) selectFilter;
  final int selectedCuisineTypeIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < filterList.length; i++)
            GestureDetector(
              onTap: () {
                selectFilter(i);
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(70),
                      width: getProportionateScreenWidth(50),
                      margin: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(12)),
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: selectedCuisineTypeIndex == i
                              ? Border.all(width: 3, color: kPrimaryColor)
                              : Border.fromBorderSide(BorderSide.none)),
                      child: Icon(
                        i == 0
                            ? Icons.filter_alt_outlined
                            : Icons.no_food_sharp,
                        size: 40,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    Text(filterList.elementAt(i).cuisineName,
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
