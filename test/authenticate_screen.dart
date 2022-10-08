import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myliveevent/main.dart';
import 'package:myliveevent/ui/profil/authenticate/authenticate_screen.dart';

void main() {
  testWidgets('auth test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AuthenticateScreen(),));

  });
}
