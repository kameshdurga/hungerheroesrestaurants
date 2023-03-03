import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/LoggedUser.dart';
import '../models/Menu.dart';
import '../models/Menu.dart';
import '../models/Restaurants.dart';

import '../models/MenuItems.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'restaurant_menu_new.dart';

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({Key? key}) : super(key: key);

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenuPage> {
  final APIService _apiService = APIService();
  Restaurants? _restaurant;
  late MenuItems menuItems;
  List<Menu>? items;
  bool _isLoading = true;
  List<String> imageUrls = ['', '', ''];

  final StorageService _storageService = StorageService();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  List<Menu> values = [];

  @override
  void initState() {
    super.initState();
    _getRestaurant();
  }

  _getRestaurant() async {
    try {
      if (loggedUser.restaurantUser == null) {
        return;
      }

      _apiService.getRestaurantFuture().then((result) async {
        // This code will be executed after fetchFirstData is completed
        print(result); // "First Data"
        final json = result!.data!.Menu;
        print("json is"); // "First Data"

        if (json == null || json.isEmpty) {
          setState(() {
            print("setting state for null menu");
            _restaurant = result.data!;
            _isLoading = false;
          });
          return;
        }
        final data = jsonDecode(json);
        menuItems = MenuItems.fromJson(data);
        var imageurlslocal = await getImageUrls(menuItems);

        setState(() {
          print("setting state ");
          int index = 0;
          for (String imageurl in imageurlslocal!) {
            print("imageurl in loop" + index.toString());
            print(imageurl);
            imageUrls[index] = imageurl;
            print("imageUrls in loop" + imageUrls[index]);

            index = index + 1;
          }
          _restaurant = result.data!;
          print("menu in json format is " + json);
          items = menuItems.menus;
        });
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  Future<List<String>?> getImageUrls(MenuItems menuitems) async {
    List<String> imageurlslocal = [];
    try {
      for (Menu item in menuitems.menus) {
        print("getting image for:");
        print(item.imageKey);
        final imageUrl = await _storageService.getUrl(item.imageKey);
        print(imageUrl!.url.toString());
        imageurlslocal.add(imageUrl!.url.toString());
      }
      return imageurlslocal;
    } catch (e) {
      print('Error retrieving image URLs: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurant == null ||
        _restaurant!.Menu == null ||
        _restaurant!.Menu!.isEmpty) {
      Menu menu1 = Menu(item: "", price: "", imageKey: "");
      Menu menu2 = Menu(item: "", price: "", imageKey: "");
      Menu menu3 = Menu(item: "", price: "", imageKey: "");
      List<Menu> menus = [menu1, menu2, menu3];
      values = menus;
      MenuItems menuItems = MenuItems(menus: menus);
      return MaterialApp(
          home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Editable List'),
              automaticallyImplyLeading: true),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RestaurantMenuNewDemo(
                  imageUrls: imageUrls,
                  menu: menuItems,
                  restaurantId: _restaurant == null ? '' : _restaurant!.id,
                ),
          floatingActionButton: FloatingActionButton(
            child: const Text("Submit"),
            onPressed: () {
              print("printinggg on submit");
              print(values[0].item);

              MenuItems menuItems = MenuItems(menus: values);
              print("done saving on submit");

              _apiService
                  .saveMenu(jsonEncode(menuItems), _restaurant!.id)
                  .then((result) {
                print("done saving on submit");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data saved successfully!'),
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
          ),
        ),
      ));
    } else {
      print("_restaurant is not null , loading again");
      print(imageUrls[0]);
      values = items!;
      setState(() {
        _isLoading = false;
      });

      return MaterialApp(
        home: SafeArea(
            child: Scaffold(
          key: _scaffoldMessengerKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(' Menu items'),
            automaticallyImplyLeading: true,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RestaurantMenuNewDemo(
                  imageUrls: imageUrls,
                  menu: menuItems,
                  restaurantId: _restaurant!.id,
                ),
          floatingActionButton: FloatingActionButton(
            child: Text("Submit"),
            onPressed: () {
              print("printing on submit");
              print(values[0].item);

              MenuItems menuItems = MenuItems(menus: values);
              print("done saving on submit");

              _apiService
                  .saveMenu(jsonEncode(menuItems), _restaurant!.id)
                  .then((result) {
                print("done saving on submit");

                print("context is ");
                print(context);

                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('Data saved successfully!'),
                    duration: Duration(seconds: 10),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            },
          ),
        )),
      );
    }
  }
}

class EditableList extends StatefulWidget {
  final List<Menu> items;
  final bool isActive;
  final Function(String, int) addItem;

  final Function(String, int) addPrice;
  final List<String> images;

  final String restaurantId;

  const EditableList(
      {required this.items,
      required this.isActive,
      required this.restaurantId,
      required this.addItem,
      required this.addPrice,
      required this.images});

  @override
  _EditableListState createState() => _EditableListState();
}

class _EditableListState extends State<EditableList> {
  late List<Menu> _editedItems;
  late bool _isActive;
  String item1 = "";
  String price1 = "";
  String imageKey1 = "";
  String item2 = "";
  String price2 = "";
  String imageKey2 = "";
  String item3 = "";
  String price3 = "";
  String imageKey3 = "";

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    print("widget item is");
    print(widget.items[0].item);
    setState(() {
      _editedItems = List.from(widget.items);
    });
  }

  @override
  void didUpdateWidget(covariant EditableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget called after parent change");

    setState(() {
      _isActive = widget.isActive;
      _editedItems = widget.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("reloading after parent");
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _editedItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: widget.images.isNotEmpty == true
                        ? Image.network(widget.images[index])
                        : Text('Image URL is null or empty')),
                title: TextField(
                  controller:
                      TextEditingController(text: _editedItems[index].item),
                  onChanged: (value) {
                    widget.addItem(value, index);
                  },
                ),
                subtitle: TextField(
                  controller:
                      TextEditingController(text: _editedItems[index].price),
                  onChanged: (value) {
                    widget.addPrice(value, index);
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ItemWidget extends StatefulWidget {
  final Menu item;
  final Function(Menu) onChanged;

  const ItemWidget({required this.item, required this.onChanged});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    print("widget.item.item is ");
    print(widget.item);
    setState(() {
      _nameController = TextEditingController(text: widget.item.item);
      _priceController = TextEditingController(text: widget.item.price);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final editedItem = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditItemScreen(item: widget.item)));
        if (editedItem != null) {
          widget.onChanged(editedItem);
        }
      },
      child: ListTile(
        title: Text(widget.item.item),
        subtitle: Text('Price: ${widget.item.price}'),
      ),
    );
  }
}

class EditItemScreen extends StatefulWidget {
  final Menu item;

  const EditItemScreen({required this.item});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  var uploadimage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.item);
    _priceController = TextEditingController(text: widget.item.price);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Item'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          uploadimage != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ElevatedButton(
            onPressed: () {
              final editedItem = Menu(
                  item: _nameController.text,
                  price: _priceController.text,
                  imageKey: uploadimage);
              Navigator.of(context).pop(editedItem);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
