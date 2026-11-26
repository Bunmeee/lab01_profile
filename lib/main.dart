import 'package:material_ui/material_ui.dart';

void main() => runApp(
  MaterialApp(
    title: 'Lab L1',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const HomePage(),
  ),
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab L1 · 67103747')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 96),
            Text('Natthaphum Sriwiboon - 67103747'),
          ],
        ),
      ),
    );
  }
}