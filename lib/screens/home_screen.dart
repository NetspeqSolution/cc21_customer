import 'package:cc21_customer/helpers/constants.dart';
import 'package:cc21_customer/helpers/preference_manager.dart';
import 'package:cc21_customer/helpers/size_config.dart';
import 'package:cc21_customer/screens/cart/cart_screen.dart';
import 'package:cc21_customer/screens/notification/notification_screen.dart';
import 'package:cc21_customer/screens/orders/order_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/image_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../helpers/location_service.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  void initState() {
    super.initState();
    getLocation();
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

  getLocation() async {
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

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.popAndPushNamed(context, CartScreen.routeName);
    } else if (index == 2) {
      Navigator.popAndPushNamed(context, NotificationScreen.routeName);
    } else if (index == 3) {
      Navigator.popAndPushNamed(context, OrderScreen.routeName);
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
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
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
                                  maxHeight: getProportionateScreenHeight(100)),
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
                                      await getCurrentLocation();
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Select Current",
                                          style:
                                              kh4.copyWith(color: kPrimaryColor),
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
                                onPressed: () {
                                  if (validateSelectedLocation())
                                    Navigator.pop(context);
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
                  CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImage.isEmpty
                          ? AssetImage('assets/images/user_img.png')
                          : imageProviderFromBase64String(profileImage)),
                ],
              ),
            ),
            Expanded(
              child: Center(child: Text("Home")),
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
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
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
}
