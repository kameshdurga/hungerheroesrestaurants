import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import '../models/Menu.dart';
import '../models/MenuItems.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../models/Restaurants.dart';

class RestaurantMenuNewDemo extends StatefulWidget {
  const RestaurantMenuNewDemo(
      {Key? key,
      required this.menu,
      required this.imageUrls,
      required this.restaurantId});

  final MenuItems menu;
  final List<String> imageUrls;
  final String restaurantId;

  @override
  State<RestaurantMenuNewDemo> createState() =>
      // ignore: no_logic_in_create_state
      _RestaurantMenuNewDemoState(menu, imageUrls);
}

class _RestaurantMenuNewDemoState extends State<RestaurantMenuNewDemo> {
  bool _isEditing = true;

  final _storageServce = StorageService();
  final _apiServce = APIService();

  final _formKey = GlobalKey<FormState>();

  final MenuItems menu;
  final List<String> imageUrls;

  PickedFile? uploadimage1;
  PickedFile? uploadimage2;
  PickedFile? uploadimage3;
  JsonWebToken? token;
  //variable for choosed file
  Restaurants? restaurants;
  final TextEditingController _item1Controller = TextEditingController();
  final TextEditingController _price1Controller = TextEditingController();
  final TextEditingController _item2Controller = TextEditingController();
  final TextEditingController _price2Controller = TextEditingController();
  final TextEditingController _item3Controller = TextEditingController();
  final TextEditingController _price3Controller = TextEditingController();

  _RestaurantMenuNewDemoState(this.menu, this.imageUrls);

  @override
  void initState() {
    super.initState();
    _populateMenu();
  }

  Future<void> _populateMenu() async {
    try {
      setState(() {
        _item1Controller.text = menu.menus[0].item;
        _price1Controller.text = menu.menus[0].price;
        _item2Controller.text = menu.menus[1].item;
        _price2Controller.text = menu.menus[1].price;
        _item3Controller.text = menu.menus[2].item;
        _price3Controller.text = menu.menus[2].price;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> chooseImage(int index) async {
    var choosedimage = await picker.getImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      if (index == 0) {
        uploadimage1 = choosedimage;
      } else if (index == 1) {
        uploadimage2 = choosedimage;
      } else {
        uploadimage3 = choosedimage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        Text(restaurants == null ? "" : restaurants!.Name!),
                        const Text(
                          'Menu item 1:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _item1Controller,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter menu item name...',
                            labelText: 'Name',
                          ),
                          enabled: _isEditing,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter price',
                            labelText: 'price',
                          ),
                          enabled: _isEditing,
                          controller: _price1Controller,
                        ),
                        Container(
                          child: imageUrls.isNotEmpty && imageUrls[0].isNotEmpty
                              ? Image(
                                  image: NetworkImage(imageUrls[0]),
                                  fit: BoxFit.cover,
                                  width: 50, // desired thumbnail width
                                  height: 50, // desired thumbnail height
                                )
                              : const Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
                        ),
                        uploadimage1 != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(uploadimage1!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : const Text(
                                "Add or Change Image",
                                style: TextStyle(fontSize: 20),
                              ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              chooseImage(0); // call choose image function
                            },
                            icon: const Icon(Icons.folder_open),
                            color: Colors.deepOrangeAccent,
                            tooltip: "CHOOSE IMAGE",
                          ),
                        ),
                        const Divider(
                          color: Colors.red,
                          height: 20,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const Text(
                          'Menu item 2:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _item2Controller,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter menu item name...',
                            labelText: 'Name',
                          ),
                          enabled: _isEditing,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter price',
                            labelText: 'price',
                          ),
                          enabled: _isEditing,
                          controller: _price2Controller,
                        ),
                        Container(
                          child: imageUrls.isNotEmpty && imageUrls[1].isNotEmpty
                              ? Image(
                                  image: NetworkImage(imageUrls[1]),
                                  fit: BoxFit.cover,
                                  width: 50, // desired thumbnail width
                                  height: 50, // desired thumbnail height
                                )
                              : const Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
                        ),
                        uploadimage2 != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(uploadimage2!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : const Text(
                                "Add or Change Image",
                                style: TextStyle(fontSize: 20),
                              ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              chooseImage(1); // call choose image function
                            },
                            icon: const Icon(Icons.folder_open),
                            color: Colors.deepOrangeAccent,
                            tooltip: "CHOOSE IMAGE",
                          ),
                        ),
                        const Divider(
                          color: Colors.red,
                          height: 20,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const Text(
                          'Menu item 3:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _item3Controller,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter menu item name...',
                            labelText: 'Name',
                          ),
                          enabled: _isEditing,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter price',
                            labelText: 'price',
                          ),
                          enabled: _isEditing,
                          controller: _price3Controller,
                        ),
                        Container(
                          child: imageUrls.isNotEmpty && imageUrls[2].isNotEmpty
                              ? Image(
                                  image: NetworkImage(imageUrls[2]),
                                  fit: BoxFit.cover,
                                  width: 50, // desired thumbnail width
                                  height: 50, // desired thumbnail height
                                )
                              : const Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
                        ),
                        uploadimage3 != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(uploadimage3!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : const Text(
                                "Add or Change Image",
                                style: TextStyle(fontSize: 20),
                              ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              chooseImage(2); // call choose image function
                            },
                            icon: const Icon(Icons.folder_open),
                            color: Colors.deepOrangeAccent,
                            tooltip: "CHOOSE IMAGE",
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 40,
                          thickness: 4,
                          indent: 20,
                          endIndent: 20,
                        ),
                        IconButton(
                          icon: Icon(_isEditing ? Icons.save : Icons.edit),
                          onPressed: () async {
                            if (!_isEditing) {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                              return;
                            }
                            setState(() {
                              _isEditing = !_isEditing;
                            });

                            print("calling create menu new");

                            List<String> menuKeys = [
                              _item1Controller.text +
                                  "-" +
                                  Random().nextInt(1111111111).toString(),
                              _item2Controller.text +
                                  "-" +
                                  Random().nextInt(1111111111).toString(),
                              _item3Controller.text +
                                  "-" +
                                  Random().nextInt(1111111111).toString()
                            ];

                            Menu menu1 = Menu(
                                item: _item1Controller.text,
                                price: _price1Controller.text,
                                imageKey: menuKeys[0]);
                            Menu menu2 = Menu(
                                item: _item2Controller.text,
                                price: _price2Controller.text,
                                imageKey: menuKeys[1]);
                            Menu menu3 = Menu(
                                item: _item3Controller.text,
                                price: _price3Controller.text,
                                imageKey: menuKeys[2]);

                            MenuItems menuItems = MenuItems(menus: [
                              menu1,
                              menu2,
                              menu3,
                            ]);
                            print("done saving on submit");

                            final result =
                                await _storageServce.uploadMenuWithImages(
                                    menuKeys,
                                    [
                                      uploadimage1!,
                                      uploadimage2!,
                                      uploadimage3!
                                    ],
                                    jsonEncode(menuItems),
                                    widget.restaurantId);

                            // final restaurants = await _apiService
                            //     .saveRestaurant(res, uploadimage);

                            print("done update menu....");
                          },
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
