import 'dart:io';

import 'package:amplify_core/src/types/storage/get_url_result.dart';
import 'package:flutter/material.dart';
import '../models/LoggedUser.dart';
import '../models/RestaurantUser.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../models/Restaurants.dart';
import 'home_page.dart';

class FormWidgetsDemo extends StatefulWidget {
  FormWidgetsDemo({
    Key? key,
  });

  @override
  State<FormWidgetsDemo> createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  bool _isEditing = true;

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

  String restaurantImageUrl = "";
  final StorageService _storageService = StorageService();

  PickedFile? uploadimage; //variable for choosed file
  final APIService _apiService = APIService();
  Restaurants? restaurants;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contact1Controller = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _contact2Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _menuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getRestaurants();
  }

  Future<void> _getRestaurants() async {
    try {
      var _restaurants = _apiService.getRestaurantFuture();

      _restaurants.then(
        (value) {
          setState(() async {
            print("restaurants is getting initialized");
            restaurants = value!.data;
            print("---------------restaurants-------------------------------");
            print(restaurants);

            _idController.text = restaurants!.id!;

            _nameController.text = restaurants!.Name!;
            _addressController.text = restaurants!.Address!;
            _cityController.text = restaurants!.City!;
            _stateController.text = restaurants!.State!;
            _zipCodeController.text = restaurants!.Zipcode == null
                ? ""
                : restaurants!.Zipcode!.toString();
            _emailController.text =
                restaurants!.Email == null ? "" : restaurants!.Email!;
            _contact1Controller.text =
                restaurants!.Contact1 == null ? "" : restaurants!.Contact1!;
            _phone1Controller.text =
                restaurants!.Phone1 == null ? "" : restaurants!.Phone1!;
            _contact2Controller.text =
                restaurants!.Contact2 == null ? "" : restaurants!.Contact2!;
            _phone2Controller.text =
                restaurants!.Phone2 == null ? "" : restaurants!.Phone2!;
            _menuController.text =
                restaurants!.Menu == null ? "" : restaurants!.Menu!;

            if (restaurants!.imagekey != null) {
              String imageUrl = await _getImageUrl(restaurants!.imagekey!);
              setState(() {
                restaurantImageUrl = imageUrl;
              });
            }
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

  Future<void> chooseImage() async {
    var choosedimage = await picker.getImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("restaurants value in build");
    print(restaurants);
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
                        Text(restaurants == null ? "" : restaurants!.Name!),
                        TextFormField(
                          controller: _nameController,
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
                        ),
                        Container(
                          child: restaurantImageUrl.isNotEmpty
                              ? Image(
                                  image: NetworkImage(restaurantImageUrl),
                                  fit: BoxFit.cover,
                                  width: 50, // desired thumbnail width
                                  height: 50, // desired thumbnail height
                                )
                              : const Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
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
                          controller: _addressController,
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
                          controller: _cityController,
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
                          controller: _stateController,
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
                          controller: _zipCodeController,
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
                          controller: _emailController,
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
                          controller: _contact1Controller,
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
                          controller: _phone1Controller,
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
                          controller: _contact2Controller,
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
                          controller: _phone2Controller,
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
                                id: _idController.text,
                                Name: _nameController.text,
                                Address: _addressController.text,
                                City: _cityController.text,
                                State: _stateController.text,
                                Zipcode: int.parse(_zipCodeController.text),
                                Email: _emailController.text,
                                Contact1: _contact1Controller.text,
                                Phone1: _phone1Controller.text,
                                Contact2: _contact2Controller.text,
                                Phone2: _phone2Controller.text,
                                Menu: _menuController.text);

                            Future<String?> imageName = _storageServce
                                .uploadImage(title, uploadimage, res);

                            imageName.then((processedData) {
                              print('Processed user data: $processedData');
                            }).catchError((error) {
                              print('An error occurred: $error');
                            });

                            // final restaurants = await _apiService
                            //     .saveRestaurant(res, uploadimage);

                            print("done update restaurants....");
                          },
                        ),
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () async {
                            RestaurantUser user = RestaurantUser(
                                Email: loggedUser.restaurantUser!.Email,
                                id: loggedUser.restaurantUser!.id,
                                RestaurantsID: null,
                                Phone: loggedUser.restaurantUser!.Phone,
                                UserStatus:
                                    loggedUser.restaurantUser!.UserStatus);
                            final updatedUser =
                                await _apiService.updateUser(user);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Deregistered successfully!'),
                                duration: Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            Future.delayed(const Duration(seconds: 4), () {
                              Navigator.pushNamed(context, '/');
                            });
                          },
                          child: Text('DeRegister'),
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

  Future<String> _getImageUrl(String imageKey) async {
    final imageUrl = await _storageService.getUrl(imageKey);

    return imageUrl!.url.toString();
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
