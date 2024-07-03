
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

final dio = Dio();

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double widgetMargin = 8;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Tasks'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(widgetMargin),
                  child: ElevatedButton(
                    onPressed: () async {
                      // TODO Exercise 1 - Perform an async operation using async/await
                      ref.watch(responseProvider.notifier).state = "Loading...";
                      String result = await fetchData();
                      ref.watch(responseProvider.notifier).state = result;
                    },
                    child: const Text('Async/Await Task'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(widgetMargin),
                  child: ElevatedButton(
                    onPressed: () {
                      // Exercise 2 - Use Provider for state management
                      // Increment the counter
                      ref.watch(counterProvider.notifier).state++;
                    },
                    child: const Text('Provider Task'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(widgetMargin),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO
                      // Exercise 3 - Use Riverpod for state management
                      // Increment the counter
                      ref
                          .watch(riverpodStateNotifierProvider.notifier)
                          .increment();
                    },
                    child: const Text('Riverpod Task'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(widgetMargin),
                  child: ElevatedButton(
                    onPressed: () async {
                      // TODO Exercise 4 - Make an HTTP request using the HTTP package
                      ref.watch(httpTaskProvider.notifier).state = "Loading...";
                      final response = await http.get(Uri.parse(
                          'https://jsonplaceholder.typicode.com/posts/11'));
                      ref.watch(httpTaskProvider.notifier).state =
                          response.body.toString();
                    },
                    child: const Text('HTTP Task'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(widgetMargin),
                  child: ElevatedButton(
                    onPressed: () async {
                      // TODO  Exercise 5 - Make an HTTP request using Dio and show it in App Screen
                      ref.watch(dioTaskProvider.notifier).state =
                          "Requesting..";
                      // We create the client only once on app startup
                      final response = await dio
                          .get("https://jsonplaceholder.typicode.com/posts/8");
                      final text = response.data.toString();
                      ref.watch(dioTaskProvider.notifier).state = text;
                    },
                    child: const Text('Dio Task'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: widgetMargin, horizontal: widgetMargin * 3),
                  child: Text(ref.watch(responseProvider).toString()),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: widgetMargin, horizontal: widgetMargin * 3),
                  child: Text("Counter value: ${ref.watch(counterProvider)}"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: widgetMargin, horizontal: widgetMargin * 3),
                  child: Text(
                      "Riverpod counter value: ${ref.watch(riverpodStateNotifierProvider)}"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: widgetMargin, horizontal: widgetMargin * 3),
                  child: Text(
                      "Http task response:\n ${ref.watch(httpTaskProvider)}"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: widgetMargin, horizontal: widgetMargin * 3),
                  child: Text(
                      "Dio task response:\n ${ref.watch(dioTaskProvider)}"),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<String> fetchData() async {
  // TODO get json from url and show as text
  // 'https://jsonplaceholder.typicode.com/posts/1'

  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return response.body.toString();
  } else {
    // If the server did not return an OK response, throw an exception
    throw Exception('Failed to load data');
  }
}

// TODO create a state notifier
final responseProvider = StateProvider((ref) => "Nothing to show here");
final counterProvider = StateProvider((ref) => 0);
final httpTaskProvider =
    StateProvider((ref) => "No https request was made, yet");
final dioTaskProvider = StateProvider((ref) => "No request was made, yet");

// TODO create class for state notifier
class RiverpodStateNotifier extends StateNotifier<int> {
  RiverpodStateNotifier([super.state = 0]);

  void increment() {
    state += 1;
  }
}

final riverpodStateNotifierProvider =
    StateNotifierProvider((ref) => RiverpodStateNotifier(10));
