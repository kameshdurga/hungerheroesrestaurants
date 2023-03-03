import 'dart:typed_data';

import 'package:amplify_core/src/types/storage/base/storage_operation_options.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/Restaurants.dart';
import 'api_service.dart';

final picker = ImagePicker();

class StorageService {
  APIService apiService = APIService();
  // Future<void> downloadFile() async {
  //   const filepath = '.' + '/example.txt';
  //   final file = File(filepath);

  //   try {
  //     final result = await Amplify.Storage.downloadFile(
  //       key: 'ExampleKey',
  //       local: file,
  //       onProgress: (progress) {
  //         print('Fraction completed: ${progress.getFractionCompleted()}');
  //       },
  //     );
  //     final contents = result.file.readAsStringSync();
  //     // Or you can reference the file that is created above
  //     // final contents = file.readAsStringSync();
  //     print('Downloaded contents: $contents');
  //   } on StorageException catch (e) {
  //     print('Error downloading file: $e');
  //   }
  // }

  String key = "";

  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);

  ValueNotifier<double> getUploadProgress() {
    return uploadProgress;
  }

  void resetUploadProgress() {
    uploadProgress.value = 0;
  }

  Future<StorageGetUrlResult?> getUrl(String? key) async {
    try {
      //uploadFile();
      print("calling get url for the key " + key!);

      // ListResult s3List = await Amplify.Storage.list();
      // s3List.items.forEach((element) {
      //   print("element key is" + element.key);
      //   key = element.key;
      // });

      S3GetUrlOptions options = const S3GetUrlOptions(
          expiresIn: Duration(seconds: 100000),
          accessLevel: StorageAccessLevel.guest);
      StorageGetUrlResult result =
          await Amplify.Storage.getUrl(key: key, options: options).result;
      print('GetUrl done: ');
      return result;
    } catch (e) {
      print('GetUrl Err: ' + e.toString());
      print(e);
    }
    return null;
  }

  listObjectsFromS3() async {
    try {
      print("calling list objects");
      StorageListResult s3List = await Amplify.Storage.list().result;
      s3List.items.forEach((element) {
        print("element key is" + element.key);
      });
    } catch (e) {
      print("exception occured listing objects" + e.toString());
    }
  }

  uploadFile() async {
    print("upload file continue");
    try {
      //File file = File('/Users/durgakam/Downloads/fc2.jpg');
      final fileName = DateTime.now().toIso8601String();
      final result = await Amplify.Storage.uploadFile(
              localFile: AWSFile.fromPath('/Users/durgakam/Downloads/fc2.jpg'),
              key: "fc2")
          .result;
    } catch (e) {
      print("upload file failed");
      print(e);
    }
  }

  Future<String?> uploadImage(
      String name, PickedFile? pickedFile, Restaurants restaurant) async {
    // Select image from user's gallery

    var imageFile = pickedFile;

    if (pickedFile == null) {
      safePrint('No image selected');
      return null;
    }

    // Upload image with the current time as the key
    final key = name + "-" + DateTime.now().millisecondsSinceEpoch.toString();

    Restaurants localRestaurant = restaurant.copyWith(imagekey: key);

    final file = AWSFile.fromPath(imageFile!.path);
    try {
      final StorageUploadFileOperation<
              StorageUploadFileRequest<StorageOperationOptions>,
              StorageUploadFileResult<StorageItem>> result =
          Amplify.Storage.uploadFile(
        localFile: file,
        key: key,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );
      result.result
          .whenComplete(() => {APIService().updateRestaurant(localRestaurant)});
      safePrint('Successfully uploaded image: ${result.result}');
      return key;
    } on StorageException catch (e) {
      safePrint('Error uploading image: $e');
    }
    return null;
  }

  Future<void> uploadImages(
      List<PickedFile> images, List<String> menuNames) async {
    // List to store the URLs of the uploaded images

    // Loop through each image file and upload it
    int index = 0;
    for (PickedFile image in images) {
      // Upload the image and get the URL
      final file1 = AWSFile.fromPath(image.path);
      Amplify.Storage.uploadFile(
        localFile: file1,
        key: menuNames[index],
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );

      index++;
    }
  }

  Future<String?> uploadMenuWithImages(List<String> menuNames,
      List<PickedFile> pickedFiles, String menu, String restaurantId) async {
    await uploadImages(pickedFiles, menuNames);
    apiService.getRestaurantById(restaurantId).then(
      (restaurant) {
        print("menu is ");
        print(menu);
        var updatableRestaurant = restaurant!.copyWith(Menu: menu);
        apiService.updateRestaurant(updatableRestaurant);
      },
    );
    return null;
  }
}
