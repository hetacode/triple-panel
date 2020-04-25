import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triple_panel/components/side.panel.dart';
import 'package:triple_panel/controllers/triple.controller.dart';

import 'package:triple_panel/triple_panel.dart';

void main() {
  testWidgets('When TriplePanel has only leftPanel prop that should have only one TripleSidePanel with Left side prop', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          leftPanelIsOpen: false,
          leftPanel: Container(),
          leftHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();

    expect(sidePanels.length, equals(1));
    expect(sidePanels.first.side, equals(TripleSidePanelSide.Left));
  });

  testWidgets('When TriplePanel has leftPanel and rightPanel prop shold have exactly two TripleSidePanel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          leftPanelIsOpen: false,
          leftPanel: Container(),
          leftHookChild: Test(),
          rightPanel: Container(),
          rightHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();

    expect(sidePanels.length, equals(2));
    expect(sidePanels.first.side, equals(TripleSidePanelSide.Left));
    expect(sidePanels.last.side, equals(TripleSidePanelSide.Right));
  });

  testWidgets('autoHideHooks set true should show empty Container instead of hook button when any panel is open', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          autoHideHooks: true,
          leftPanelIsOpen: true,
          leftPanel: Container(),
          leftHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();
    expect(sidePanels.first.hookChild, isA<Container>().having((h) => h.child, "child", null));
  });

  testWidgets('autoHideHooks set false should show Test widget with Padding parent when any panel is open', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          autoHideHooks: false,
          leftPanelIsOpen: true,
          leftPanel: Container(),
          leftHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();

    expect(sidePanels.first.hookChild, isA<Padding>());
    expect((sidePanels.first.hookChild as Padding).child, isA<Test>());
  });

  testWidgets('autoHideHooks set true and panel is close - hook button should be show', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          autoHideHooks: true,
          leftPanelIsOpen: false,
          leftPanel: Container(),
          leftHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();

    expect(sidePanels.first.hookChild, isA<Padding>());
    expect((sidePanels.first.hookChild as Padding).child, isA<Test>());
  });

  testWidgets('autoHideHooks set false and panel is close - hook button should be show', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TriplePanel(
          controller: TriplePanelController(),
          autoHideHooks: true,
          leftPanelIsOpen: false,
          leftPanel: Container(),
          leftHookChild: Test(),
          body: Container(),
        ),
      ),
    );

    var sidePanelsRaw = find.byType(TripleSidePanel);
    var sidePanels = sidePanelsRaw.evaluate().map((m) => m.widget as TripleSidePanel).toList();

    expect(sidePanels.first.hookChild, isA<Padding>());
    expect((sidePanels.first.hookChild as Padding).child, isA<Test>());
  });
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
