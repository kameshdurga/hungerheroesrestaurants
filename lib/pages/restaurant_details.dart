import 'package:flutter/material.dart';

import '../models/LoggedUser.dart';
import '../models/RestaurantUser.dart';
import '../models/Restaurants.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'home_page.dart';

class RestaurantDetailsPage extends StatefulWidget {
  const RestaurantDetailsPage(
      {Key? key,
      required this.imageKey,
      required this.name,
      required this.city,
      required this.restaurant,
      required this.id})
      : super(key: key);

  final String imageKey;
  final String name;
  final String city;
  final Restaurants restaurant;
  final String id;

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  final StorageService _storageService = StorageService();
  final _apiService = APIService();

  final imageList = <String>[];

  String _imagekey = "";

  _RestaurantDetailsPageState() {
    // ignore: unnecessary_this
  }

  @override
  void initState() {
    super.initState();
    _getRestaurantImage();
  }

  Future<void> _getRestaurantImage() async {
    try {
      final imageUrl = await _storageService.getUrl(widget.imageKey);

      setState(() {
        _imagekey = imageUrl?.url.toString() ?? "";
        print("got imagekey " + _imagekey);
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Image.network(
              _imagekey,
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.city,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              widget.name,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () async {
              RestaurantUser user = RestaurantUser(
                  Email: loggedUser.restaurantUser!.Email,
                  id: loggedUser.restaurantUser!.id,
                  RestaurantsID: widget.id,
                  Phone: loggedUser.restaurantUser!.Phone,
                  UserStatus: loggedUser.restaurantUser!.UserStatus);
              _apiService.updateUser(user).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registered successfully!'),
                    duration: Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                Future.delayed(const Duration(seconds: 4), () {
                  Navigator.pushNamed(context, '/');
                });
              });
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
