import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'amplifyconfiguration.dart';
import 'models/Cart.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/restaurant_menu.dart';
import 'pages/restaurant_setup.dart';
import 'pages/restaurants_view.dart';
// main.dart
// import 'package:flutter_stripe/flutter_stripe.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void _configureAmplify() async {
  final storage = AmplifyStorageS3();
  AmplifyAuthCognito auth = AmplifyAuthCognito();

  // final datastorePlugin =
  //     AmplifyDataStore(modelProvider: ModelProvider.instance);
  await Amplify.addPlugins(
    [
      auth,
      AmplifyAPI(modelProvider: ModelProvider.instance),
      storage,
      //datastorePlugin
    ],
  );
  await Amplify.configure(amplifyconfig);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _configureAmplify();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider<Cart>(create: (_) => Cart())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        title: 'Hunger heroes Restaurant application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: Authenticator.builder(),
        scaffoldMessengerKey: scaffoldMessengerKey,
        initialRoute: '/',
        routes: {
          "/": (context) => const MyHomePage(title: 'Restaurant Home Page'),
          "/restaurantSetup": (context) => FormWidgetsDemo(),
          "/restaurantMenu": (context) => const RestaurantMenuPage(),
          "/restaurantsListView": (context) =>
              const RestaurantsViewWidget(title: "title")
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final APIService _apiService = APIService();

  List<Restaurants> _restaurants = const [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      title: 'Order Items',
    );
  }
}
