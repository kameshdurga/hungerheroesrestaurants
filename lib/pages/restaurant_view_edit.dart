import 'dart:io';

import 'package:flutter/material.dart';
import '../models/LoggedUser.dart';
import '../models/RestaurantUser.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../models/Restaurants.dart';
import 'home_page.dart';

class RestaurantViewEditPage extends StatefulWidget {
  RestaurantViewEditPage({Key? key, required this.restaurants});

  final Restaurants restaurants;

  @override
  State<RestaurantViewEditPage> createState() => _RestaurantViewEditState();
}

class _RestaurantViewEditState extends State<RestaurantViewEditPage> {
  bool _isEditing = false;

  final _apiService = APIService();
  final _storageServce = StorageService();
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String email = '';
  String contact1Name = '';
  String contact1Phone = '';
  String contact2Name = '';
  String contact2Phone = '';

  PickedFile? uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    var choosedimage = await picker.getImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Setup'),
      ),
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
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter a name...',
                            labelText: 'Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Name,
                        ),
                        uploadimage != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(uploadimage!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : Text(
                                "No Image",
                                style: TextStyle(fontSize: 20),
                              ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              chooseImage(); // call choose image function
                            },
                            icon: Icon(Icons.folder_open),
                            color: Colors.deepOrangeAccent,
                            tooltip: "CHOOSE IMAGE",
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a Address...',
                            labelText: 'Address',
                          ),
                          onChanged: (value) {
                            address = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Address,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a City...',
                            labelText: 'City',
                          ),
                          onChanged: (value) {
                            city = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.City,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a State...',
                            labelText: 'State',
                          ),
                          onChanged: (value) {
                            state = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.State,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a Zipcode...',
                            labelText: 'Zipcode',
                          ),
                          onChanged: (value) {
                            zipCode = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Zipcode.toString(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter an Email...',
                            labelText: 'Email',
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Email,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter Contact 1...',
                            labelText: 'Contact 1 Name',
                          ),
                          onChanged: (value) {
                            contact1Name = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Contact1,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a Contact 1 Phone...',
                            labelText: 'Contact 1 Ph#',
                          ),
                          onChanged: (value) {
                            contact1Phone = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Phone1,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter Contact 2...',
                            labelText: 'Contact 2 Name',
                          ),
                          onChanged: (value) {
                            contact2Name = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Contact2,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a Contact 2 Phone...',
                            labelText: 'Contact 2 Ph#',
                          ),
                          onChanged: (value) {
                            contact2Phone = value;
                          },
                          enabled: _isEditing,
                          initialValue: widget.restaurants.Phone2,
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

                            print("calling create restaurants new");

                            print("Done uploadImage");

                            Restaurants res = Restaurants(
                                id: widget.restaurants.id,
                                Name: title,
                                Address: address,
                                City: city,
                                State: state,
                                Zipcode: int.parse(zipCode),
                                Email: email,
                                Contact1: contact1Name,
                                Phone1: contact1Phone,
                                Contact2: contact2Name,
                                Phone2: contact2Phone,
                                imagekey: widget.restaurants.imagekey);

                            // String? imageName = await _storageServce
                            //     .uploadImage(title, uploadimage, res);

                            final restaurants =
                                await _apiService.saveRestaurant(res);

                            print("done update restaurants new");
                          },
                        ),
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () async {
                            RestaurantUser user = RestaurantUser(
                                Email: loggedUser.restaurantUser!.Email,
                                id: loggedUser.restaurantUser!.id,
                                RestaurantsID: widget.restaurants.id,
                                Phone: loggedUser.restaurantUser!.Phone,
                                UserStatus:
                                    loggedUser.restaurantUser!.UserStatus);
                            final updatedUser =
                                await _apiService.updateUser(user);
                          },
                          child: Text('Register'),
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
