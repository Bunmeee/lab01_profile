import 'package:material_ui/material_ui.dart';

void main() => runApp(
  const MaterialApp(home: HomePage()),
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hello!')),
    );
  }
}