import 'package:cc21_customer/helpers/constants.dart';
import 'package:cc21_customer/helpers/size_config.dart';
import 'package:cc21_customer/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../cart/cart_screen.dart';
import '../notification/notification_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static String routeName = "/OrderScreen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if(index==1){
      Navigator.popAndPushNamed(context, CartScreen.routeName);
    }
    else if(index==2){
      Navigator.popAndPushNamed(context, NotificationScreen.routeName);
    }
    else if(index==0){
      Navigator.popAndPushNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                child: Container(
                  width: getWidthForPercentage(100),
                  height: getProportionateScreenHeight(40),
                  color: kPrimaryColor,
                  child: Center(child: Text("order "),),
                ))),
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
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: kWhite,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
