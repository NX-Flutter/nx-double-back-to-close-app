import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Given that `DoubleBackToCloseApp` was wrapped in a `Scaffold`. '
    'When back-button is tapped. '
    'Then a `SnackBar` is shown. '
    'And the app stills opened.',
    (WidgetTester tester) async {
      // Given that `DoubleBackToCloseApp` was wrapped in a `Scaffold`.
      TestWidget widget = TestWidget(withScaffold: true);
      await tester.pumpWidget(widget);

      LifecycleEventHandler eventHandler = LifecycleEventHandler();
      tester.binding.addObserver(eventHandler);

      // When back-button is tapped.
      await tester.binding.handlePopRoute();
      await tester.pump();

      // Then a `SnackBar` is shown.
      expect(find.byType(SnackBar), findsOneWidget);

      // And the app stills opened.
      expect(eventHandler.didPopRouteCount, 0);
    },
  );

  testWidgets(
    'Given that `DoubleBackToCloseApp` was NOT wrapped in a `Scaffold`. '
    'When back-button is tapped. '
    'Then an `AssertionError` is thrown. '
    'And a `SnackBar` is NOT shown.',
    (WidgetTester tester) async {
      // Given that `DoubleBackToCloseApp` was NOT wrapped in a `Scaffold`.
      TestWidget widget = TestWidget(withScaffold: false);
      await tester.pumpWidget(widget);

      expect(
        // When back-button is tapped.
        () => tester.binding.handlePopRoute(),
        // Then an `AssertionError` is thrown.
        throwsAssertionError,
      );

      // And a `SnackBar` is NOT shown.
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets(
    'Given that `DoubleBackToCloseApp` was wrapped in a `Scaffold`. '
    'When back-button is tapped twice. '
    'Then a `SnackBar` is shown only once. '
    'And the app is closed.',
    (WidgetTester tester) async {
      // Given that `DoubleBackToCloseApp` was wrapped in a `Scaffold`.
      TestWidget widget = TestWidget(withScaffold: true);
      await tester.pumpWidget(widget);

      LifecycleEventHandler eventHandler = LifecycleEventHandler();
      tester.binding.addObserver(eventHandler);

      // When back-button is tapped twice.
      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();
      await tester.pump();

      // Then a `SnackBar` is shown only once.
      expect(find.byType(SnackBar), findsOneWidget);

      // And the app is closed.
      expect(eventHandler.didPopRouteCount, 1);
    },
  );

  testWidgets(
    'Given that `DoubleBackToCloseApp` was wrapped in a `Scaffold`. '
    'And that the back-button was tapped. '
    ''
    'When the `SnackBar` collapses. '
    'And the back-button is tapped again. '
    ''
    'Then another `SnackBar` is shown. '
    'And the app stills opened.',
    (WidgetTester tester) async {
      // I could not test this properly, since the `SnackBar` never collapses,
      // even with `tester.pumpAndSettle`, so I moved this test to the
      // test_driver of the example. If anyone has any idea on why this happens
      // and how to fix it, please let me know.
    },
  );
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  int didPopRouteCount = 0;

  Future<bool> didPopRoute() {
    didPopRouteCount++;
    return super.didPopRoute();
  }
}

class TestWidget extends StatelessWidget {
  final bool withScaffold;

  TestWidget({@required this.withScaffold}) : assert(withScaffold != null);

  @override
  Widget build(BuildContext context) {
    Widget widget = DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text('Press back again to leave'),
      ),
      child: Center(
        child: Text('Hi there!'),
      ),
    );

    return MaterialApp(
      home: withScaffold ? Scaffold(body: widget) : widget,
    );
  }
}