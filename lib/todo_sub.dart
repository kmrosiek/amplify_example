import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'models/Todo.dart';

class MySub {
  StreamSubscription<GraphQLResponse<Todo>>? _subscription;
  StreamSubscription<QuerySnapshot<Todo>>? _observeQuery;
  StreamSubscription<SubscriptionEvent<Todo>>? _observeModel;

  void run() {
    subscribe();
    observeQueryForEach();
    observeQueryListen();
    observeModel();
  }

  void subscribe() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Todo.classType);
    final Stream<GraphQLResponse<Todo>> operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => print('Subscription established'),
    );
    _subscription = operation.listen(
      (event) {
        print('Subscription event data received: ${event.data}');
      },
      onError: (Object e) => print('Error in subscription stream: $e'),
    );
  }

  void observeQueryForEach() {
    Amplify.DataStore.observeQuery(Todo.classType).forEach((snapshot) =>
        print('observeQueryForEach count: ${snapshot.items.length}'));
  }

  void observeQueryListen() {
    _observeQuery = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      print('observeQueryListen count:  ${snapshot.items.length}');
    });
  }

  void observeModel() {
    _observeModel = Amplify.DataStore.observe(Todo.classType).listen(
      (event) {
        print('observeModel ${event.eventType}${event.item.name}');
      },
    );
  }

  void unsubscribe() {
    _subscription?.cancel();
    _observeQuery?.cancel();
    _observeModel?.cancel();
  }
}
