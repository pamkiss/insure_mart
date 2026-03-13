import 'package:flutter_test/flutter_test.dart';
import 'package:insure_mart/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const InsureMartApp());
    expect(find.text('insuremart'), findsOneWidget);
  });
}
