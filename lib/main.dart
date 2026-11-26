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

/// Displays the student's About Me profile and interactive like counter.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _likes = 0;

  void _like() => setState(() => _likes++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab L1 · 67103747')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 96),
            const Text('Natthaphum Sriwiboon - 67103747'),
            Text('Likes: $_likes'),
            FilledButton(
              onPressed: _like,
              child: const Text('Like'),
            ),
          ],
        ),
      ),
    );
  }
}
