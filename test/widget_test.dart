import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:lab01_profile/main.dart';

void main() {
  testWidgets('HomePage displays student profile and increments likes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );

    expect(find.text('Lab L1 · 67103747'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('Natthaphum Sriwiboon - 67103747'), findsOneWidget);
    expect(find.text('Likes: 0'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    final likeButton = find.widgetWithText(FilledButton, 'Like');
    expect(likeButton, findsOneWidget);

    await tester.tap(likeButton);
    await tester.pump();
    expect(find.text('Likes: 1'), findsOneWidget);

    for (var i = 0; i < 19; i++) {
      await tester.tap(likeButton);
    }
    await tester.pump();
    expect(find.text('Likes: 20'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('HomePage stays centered without overflow in landscape', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 720);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );

    expect(find.text('Lab L1 · 67103747'), findsOneWidget);
    expect(find.text('Natthaphum Sriwiboon - 67103747'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
