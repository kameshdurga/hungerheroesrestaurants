import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'home_page.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ElevatedButton(
    //   style: raisedButtonStyle,
    //   child: Text('Sign Out'),
    //   onPressed: () async {
    //     try {
    //       await Amplify.Auth.signOut();
    //       // Perform any other actions needed after sign out
    //     } catch (error) {
    //       print(error);
    //     }
    //   },
    // );

    return IconButton(
      onPressed: () async {
        try {
          await Amplify.Auth.signOut(); // call choose image function
        } catch (error) {
          print(error);
        }
      },
      icon: Icon(Icons.logout_rounded),
      color: Colors.deepOrangeAccent,
      tooltip: "CHOOSE IMAGE",
    );
  }
}

class AppBarWithSignOutButton extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My App'),
      actions: [
        SignOutButton(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
