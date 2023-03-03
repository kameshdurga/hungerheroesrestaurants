import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../models/LoggedUser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Cart.dart';
import '../models/ModelProvider.dart';
import '../models/RestaurantUser.dart';
import '../models/RestaurantUser.dart';

class APIService {
  Future<List<Restaurants?>?> getRestaurants() async {
    try {
      print("calling actually now");

      final request = ModelQueries.list(Restaurants.classType);
      final response = await Amplify.API.query(request: request).response;
      List<Restaurants?>? restaurants = response.data?.items;
      print("called actually now");
      print(restaurants?.first?.id);
      print(restaurants?.length);
      // restaurants?.sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
      return restaurants;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<List<Restaurants?>?> getRestaurantsByZipCode(String zip) async {
    try {
      print("calling actually now");

      final queryPredicate = Restaurants.ZIPCODE.eq(zip);
      final request = ModelQueries.list<Restaurants>(Restaurants.classType,
          where: queryPredicate);

      final response = await Amplify.API.query(request: request).response;
      List<Restaurants?>? restaurants = response.data?.items;

      return restaurants;
      // restaurants?.sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
      return restaurants;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<Restaurants?> getRestaurant() async {
    try {
      print("calling actually now");

      final request = ModelQueries.get(
          Restaurants.classType, loggedUser.restaurantUser!.RestaurantsID!);
      final response = await Amplify.API.query(request: request).response;
      Restaurants? restaurants = response.data;
      // restaurants?.sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
      return restaurants;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<Restaurants?> getRestaurantById(String id) async {
    try {
      print("calling actually now");

      final request = ModelQueries.get(Restaurants.classType, id);
      final response = await Amplify.API.query(request: request).response;
      Restaurants? restaurants = response.data;
      // restaurants?.sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
      return restaurants;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<GraphQLResponse<Restaurants>?> getRestaurantFuture() async {
    try {
      print("calling actually now");

      final request = ModelQueries.get(
          Restaurants.classType, loggedUser.restaurantUser!.RestaurantsID!);
      final response = await Amplify.API.query(request: request).response;
      // restaurants?.sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
      return response;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  // query MyQuery {
//   listOrderItems(filter: {
//     ShopId: { eq: "BurgerKing"}
//     and: [
//       { LineItemId: { gt: "0" } },
//       { Status: { eq: "Notified" } }
//     ]
//   }) {
//     items {
//       id
//       ItemSKU
//       RecipientID
//       ShopId
//     }
//   }
// }

  Future<List<OrderItem?>?> getOrderItems(String id) async {
    try {
      print("calling actually now");

      const blogTitle = 'Test Blog 1';
      final queryPredicate = OrderItem.RESTAURANTSID
          .eq(id)
          .and(OrderItem.LINEITEMID.gt(0).and(OrderItem.STATUS.eq("Notified")));

      final request = ModelQueries.list<OrderItem>(OrderItem.classType,
          where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      List<OrderItem?>? orderItems = response.data?.items;
      return orderItems;
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<void> updateRestaurants(Restaurants updatedRestaurant) async {
    try {
      final request = ModelMutations.update(updatedRestaurant);
      await Amplify.API.mutate(request: request).response;
    } on Exception catch (e) {
      // _showError(e);
    }
  }

  Future<void> updateUser(RestaurantUser user) async {
    try {
      final request = ModelMutations.update(user);
      await Amplify.API.mutate(request: request).response;
    } on Exception catch (e) {
      // _showError(e);
    }
  }

  Future<void> saveRestaurant(Restaurants restaurant) async {
    try {
      print('Saving restaurant  ');

      final request = ModelMutations.create(restaurant);
      final response = await Amplify.API.mutate(request: request).response;

      Restaurants? createdRestaurant = response.data;
      if (createdRestaurant == null) {
        print('errors: ' + response.errors.toString());
        return;
      }
      print('Mutation result: ' + createdRestaurant.id);
    } on Exception catch (e) {
      //_showError(e);
    }
  }

  Future<void> updateRestaurant(Restaurants restaurant) async {
    try {
      print('updating restaurant  ');

      final request = ModelMutations.update(restaurant);
      final response = await Amplify.API.mutate(request: request).response;

      Restaurants? updatedRestaurant = response.data;
      if (updatedRestaurant == null) {
        print('errors: ' + response.errors.toString());
        return;
      }
      print('Mutation result: ' + updatedRestaurant.id);
    } on Exception catch (e) {
      //_showError(e);
    }
  }

  Future<String> saveOrderItem(OrderItem orderItem) async {
    try {
      final request = ModelMutations.create(orderItem);
      final response = await Amplify.API.mutate(request: request).response;

      OrderItem? createdOrderItem = response.data;
      if (createdOrderItem == null) {
        print('errors: ' + response.errors.toString());
        return "error";
      }
      print('Mutation result: ' + createdOrderItem.id);
      return createdOrderItem.id;
    } on Exception catch (e) {
      //_showError(e);
    }
    return "";
  }

  Future<void> updateItem(String id, String lineitemid, String status) async {
    try {
      print("calling update now for id " + id);
      print("line item id is " + lineitemid);
      print("line item status will be is " + status);

      final queryPredicate =
          OrderItem.ID.eq(id).and(OrderItem.LINEITEMID.eq(lineitemid));

      final request = ModelQueries.list<OrderItem>(OrderItem.classType,
          where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      List<OrderItem?>? orderItems = response.data?.items;
      OrderItem orderItem = orderItems!.first!;

      OrderItem newOrder = orderItem.copyWith(
        id: orderItem.getId(),
        LineItemId: orderItem.LineItemId,
        Status: status,
        ItemSKU: "BK Veggie new",
      );

      final requestUpdate = ModelMutations.update(newOrder);
      final resp = await Amplify.API.mutate(request: requestUpdate).response;

      //updateItemUsingGraphql();

      OrderItem? updatedOrder = resp.data;
      if (updatedOrder == null) {
        print('errors: ' + resp.errors.toString());
        return;
      }
      print('Mutation result: for update ' + updatedOrder.id);
      print('errors: ' + resp.errors.toString());

      print(newOrder);
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
  }

  Future<RestaurantUser?> saveUser(String email) async {
    try {
      final queryPredicate = RestaurantUser.EMAIL.eq(email);

      final userRequest = ModelQueries.list<RestaurantUser>(
          RestaurantUser.classType,
          where: queryPredicate);
      final userScanResponse =
          await Amplify.API.query(request: userRequest).response;
      List<RestaurantUser?>? users = await userScanResponse.data?.items;

      if (users != null && users.isNotEmpty) {
        print("user already exist");
        print(users.first!.Email);
        loggedUser.restaurantUser = users.first!;
        return users.first!;
      }

      RestaurantUser user = RestaurantUser(Email: email, UserStatus: "Manager");
      final request = ModelMutations.create(user);
      final response = await Amplify.API.mutate(request: request).response;

      RestaurantUser? userResponse = response.data;
      if (userResponse == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print('Mutation result: ' + userResponse.id);
      loggedUser.restaurantUser = userResponse;
      return userResponse;
    } on Exception catch (e) {
      //_showError(e);
    }
    return null;
  }

  Future<RestaurantUser?> getUserDetails(String email) async {
    try {
      print("getting user details by email");

      final queryPredicate = RestaurantUser.EMAIL.eq(email);

      final request = ModelQueries.list<RestaurantUser>(
          RestaurantUser.classType,
          where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      List<RestaurantUser?>? orderItems = response.data?.items;

      if (orderItems!.isNotEmpty) {
        return orderItems.first;
      }
    } on Exception catch (e) {
      //_showError(e);
      print("failed actually now" + e.toString());
    }
    return null;
  }

  Future<void> saveMenu(String jsonEncode, restaurantId) async {
    return getRestaurantFuture().then((result) {
      var updatedRes = result!.data!.copyWith(Menu: jsonEncode);
      return updateRestaurants(updatedRes);
    });
  }

  Future<JsonWebToken?> fetchAuthSession() async {
    try {
      // Fetch the current authentication session
      final authSession = await Amplify.Auth.fetchAuthSession();

      // Extract the session token from the auth session
      final sessionToken = authSession.isSignedIn
          ? (authSession as CognitoAuthSession).userPoolTokens!.accessToken
          : null;

      return sessionToken;
    } on AuthException catch (e) {
      print("error in getting token");
      safePrint(e.message);
    }
    return null;
  }

//   void updateItemUsingGraphql() {
//     try {
//       String graphQLDocument = '''mutation updateItem(\$id: String!, \$lineitemid: String!) {
//   updateOrderItem(input:{id: \$id,
//     LineItemId:\$lineitemid,Status:"Claimed",_version:8
//   }
//   ) {
//     id,RecipientID,Status
//   }
// }''';

//       var operation = Amplify.API.mutate(
//           request:
//               GraphQLRequest<String>(document: graphQLDocument, variables: {
//         'name': 'my first todo',
//         'description': 'todo description',
//       }));

//       var response = operation.response;
//       var data = response.data;

//       print('Mutation result: ' + data);
//     } on ApiException catch (e) {
//       print('Mutation failed: $e');
//     }
//   }
}
