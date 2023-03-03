import 'package:flutter/foundation.dart';

import 'RestaurantUser.dart';

class LoggedUser {
  RestaurantUser? restaurantUser = null;

  static final LoggedUser _instance = LoggedUser._internal();

  factory LoggedUser() {
    return _instance;
  }

  LoggedUser._internal();
}

final loggedUser = LoggedUser();
