import 'package:flutter/material.dart';
import '../pages/restaurant_details.dart';
import '../pages/restaurant_view_edit.dart';
import 'package:provider/provider.dart';
import '../models/Cart.dart';
import '../models/ModelProvider.dart';

import '../services/api_service.dart';

class RestaurantsViewWidget extends StatefulWidget {
  const RestaurantsViewWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<RestaurantsViewWidget> createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends State<RestaurantsViewWidget> {
  final APIService _apiService = APIService();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<Restaurants> _restaurants = const [];

  @override
  void initState() {
    super.initState();
    //_getRestaurants();
  }

  Future<void> _getRestaurants() async {
    try {
      final restaurants = await _apiService.getRestaurants();

      setState(() {
        _restaurants =
            restaurants?.whereType<Restaurants>().toList() ?? const [];
        print("---------------restaurants-------------------------------");
        print(_restaurants);
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> _getRestaurantsByZipCode() async {
    try {
      print("getting restaurants for ");
      print(_searchController.text);
      final restaurants =
          await _apiService.getRestaurantsByZipCode(_searchController.text);

      setState(() {
        _restaurants =
            restaurants?.whereType<Restaurants>().toList() ?? const [];
        print("---------------restaurants---");
        print(_restaurants);
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
    var cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
      ),
      // body: Restaurantwidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Zipcode',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _getRestaurantsByZipCode();
                    setState(() {
                      _searchText = _searchController.text;
                    });
                  },
                ),
              ),
              onSubmitted: (String value) {
                // This function will be called when the user submits the text field's value
                // You can perform your search logic here
                print('Submitted text: $value');
                _getRestaurantsByZipCode();
                setState(() {
                  _searchText = _searchController.text;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _getRestaurantsByZipCode();
            },
            child: const Text('Refresh restaurants data'),
          ),
          Expanded(
            child: Restaurantwidget(),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Restaurantwidget() {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: _restaurants.length,
      itemBuilder: (context, index) {
        final _restaurantItem = _restaurants[index];

        return GestureDetector(
            onTap: () {
              print("Container clicked" + _restaurantItem.Name!);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RestaurantViewEditPage(
                            restaurants: _restaurantItem,
                          )));
            },
            child: RestaurantDetailsPage(
              // ignore: unnecessary_null_in_if_null_operators
              id: _restaurantItem.id,
              imageKey: _restaurantItem.imagekey!,
              name: _restaurantItem.Name!,
              city: _restaurantItem.City!, restaurant: _restaurantItem,
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
}
