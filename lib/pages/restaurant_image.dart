import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

class RestaurantImagePage extends StatefulWidget {
  const RestaurantImagePage(
      {Key? key,
      required this.imageKey,
      required this.item,
      required this.recepient,
      required this.id,
      required this.lineItemId})
      : super(key: key);

  final String imageKey;
  final String item;
  final String recepient;
  final String id;
  final String lineItemId;

  @override
  State<RestaurantImagePage> createState() => _RestaurantImagePageState();
}

class _RestaurantImagePageState extends State<RestaurantImagePage> {
  final StorageService _storageService = StorageService();
  final APIService _apiService = APIService();
  bool isChecked = false;

  final imageList = <String>[];

  String _imagekey = "";

  _RestaurantImagePageState() {
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
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              widget.item,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.recepient,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Image(
              image: NetworkImage(_imagekey),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              flex: 3,
              // child: IconButton(
              //   icon: const Icon(Icons.check_box),
              //   onPressed: () {
              //     print("clicked the image");
              //   },
              // ),
              child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    print("on change image");
                    isChecked = value!;
                    print(isChecked);
                    if (isChecked) {
                      _apiService.updateItem(
                          widget.id, widget.lineItemId, "Claimed");
                    } else {
                      _apiService.updateItem(
                          widget.id, widget.lineItemId, "Notified");
                    }
                  });
                },
              ))
        ],
      ),
    );
  }
}
