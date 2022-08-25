import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';

import 'package:test_graphql_lambda/models/ModelProvider.dart';
import 'package:test_graphql_lambda/todo_sub.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AwsConfiguration(),
    );
  }
}

class AwsConfiguration extends StatefulWidget {
  const AwsConfiguration({Key? key}) : super(key: key);

  @override
  State<AwsConfiguration> createState() => _AwsConfigurationState();
}

class _AwsConfigurationState extends State<AwsConfiguration> {
  bool _isConfigured = false;
  final MySub _sub = MySub();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  void dispose() {
    _sub.unsubscribe();
    super.dispose();
  }

  Future<void> _configureAmplify() async {
    final datastore = AmplifyDataStore(modelProvider: ModelProvider.instance);
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    await Amplify.addPlugins([api, datastore]);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() => _isConfigured = true);
    } on AmplifyAlreadyConfiguredException {
      print(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: !_isConfigured
          ? const CircularProgressIndicator()
          : Center(
              child: ElevatedButton(
                  onPressed: () => _sub.run(), child: Text("I'm ready")),
            ));
}
