import 'package:flutter/material.dart';
import 'package:manager/collection.dart' show Collection, Model;
import 'package:manager/manager.dart'
    show
        BuildContext,
        MaterialApp,
        RM,
        ReactiveStatelessWidget,
        Scaffold,
        Widget,
        directory,
        runApp;
import 'package:path_provider/path_provider.dart';

void main() async {
  directory = await getApplicationDocumentsDirectory();
  runApp(App());
}

class App extends ReactiveStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: adnsRM.state
              .expand(
                (e) => [
                  FloatingActionButton(
                    onPressed: () {
                      _.remove(e.id);
                    },
                  ),
                ],
              )
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _.put(Adn());
          },
        ),
      ),
    );
  }
}

final _ = Collection(Adn.fromJson);

final adnsRM = RM.injectStream(
  () => _.watch(),
  initialState: _.getAll(),
);

final class Adn extends Model {
  Adn();
  Adn.fromJson(json) {
    id = json['id'] ?? '';
  }
}
