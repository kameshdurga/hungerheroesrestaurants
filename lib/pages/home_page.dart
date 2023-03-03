import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../models/Cart.dart';
import '../models/LoggedUser.dart';
import '../models/ModelProvider.dart';

import '../services/api_service.dart';
import 'restaurant_image.dart';
import 'signoute_page.dart';
import 'package:flutter/foundation.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final APIService _apiService = APIService();
  bool _loading = true;

  List<OrderItem> _orderItems = const [];
  var refreshpage = false;
  late RestaurantUser resUser;
  Restaurants? restaurants;

  @override
  void initState() {
    super.initState();
    _loadData();

    //_createDonor();
  }

  Future<void> _getOrderItems(String id) async {
    print("-----getting orderItems-------------------------------");

    try {
      if (id == null) {
        print("-----getting orderItems restaurant user is null");
        return;
      }
      print(" id is ");
      print(id);
      final orderItems = _apiService.getOrderItems(id);

      orderItems.then(
        (value) async {
          final restaurant = await _apiService
              .getRestaurantById(loggedUser.restaurantUser!.RestaurantsID!);

          setState(() {
            _orderItems = value!.whereType<OrderItem>().toList();
            print("---------------orderItems-------------------------------");
            print(_orderItems);

            restaurants = restaurant!;
          });
        },
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("loading build for home page");
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (resUser != null && resUser.RestaurantsID != null) {
      var title = restaurants != null ? restaurants!.Name : "";
      print("title is ");
      print(widget.title);
      print(title);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            (title!) + " orders",
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search),
            ),
            FloatingActionButton(
              tooltip: 'Reload items',
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
              child: const Icon(Icons.refresh),
            ),
            SignOutButton()
          ],
        ),
        body: OrderItemswidget(),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.of(context).pushNamed('/'),
              ),
              label: 'HOME',
              activeIcon: const Icon(
                Icons.home,
                color: Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.fastfood),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/restaurantSetup'),
              ),
              label: 'Restaurant',
              activeIcon: const Icon(
                Icons.restaurant,
                color: Colors.red,
              ),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.restaurant_menu),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/restaurantMenu'),
              ),
              label: 'Menu',
              activeIcon: const Icon(
                Icons.restaurant_menu,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
          leading: IconButton(
            icon: const Icon(Icons.app_registration),
            onPressed: () {},
          ),
          actions: [SignOutButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, '/restaurantsListView');
                },
                child: const Text('View  Restaurants'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, '/restaurantSetup');
                },
                child: const Text('Create a Restaurant'),
              )
            ],
          ),
        ),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget OrderItemswidget() {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: _orderItems.length,
      itemBuilder: (context, index) {
        final _orderItem = _orderItems[index];
        String? recepientid = _orderItem.RecipientID ?? "";

        return GestureDetector(
            onTap: () {
              print("Container clicked" + _orderItem.id);

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => RestaurantMenuPage(
              //             name: _restaurantItem.Name!,
              //             menu: _restaurantItem.Menu!)));
            },
            child: RestaurantImagePage(
              imageKey: "burgerking.png",
              item: _orderItem.ItemSKU!,
              recepient: recepientid,
              id: _orderItem.id,
              lineItemId: _orderItem.LineItemId,
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          indent: 20,
          endIndent: 20,
        );
      },
    );
  }

  Future<RestaurantUser?> _loadData() async {
    try {
      final awsUser = await Amplify.Auth.getCurrentUser();
      final userJson = awsUser.signInDetails.toJson();
      var saveduser = _apiService.saveUser(userJson["username"].toString());

      saveduser.then(
        (value) {
          if (value != null && value.RestaurantsID != null) {
            _getOrderItems(value.RestaurantsID!);
          }

          setState(() {
            _loading = false;
            resUser = value!;
          });
        },
      );

      return saveduser;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
    return null;
  }
}
