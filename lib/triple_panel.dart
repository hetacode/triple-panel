import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:triple_panel/components/side.panel.dart';
import 'package:triple_panel/controllers/triple.controller.dart';
import 'package:triple_panel/controllers/triple_side_panel.controller.dart';

class TriplePanel extends StatefulWidget {
  final TriplePanelController controller;
  final Widget body;
  final Widget leftPanel;
  final Widget rightPanel;
  final Widget leftHookChild;
  final Widget rightHookChild;
  final Function(bool) leftPanelOpenState;
  final Function(bool) rightPanelOpenState;
  final bool leftPanelIsOpen;
  final bool rightPanelIsOpen;

  final EdgeInsetsGeometry hookContentPadding;
  final Size hookSize;
  final Widget hookChild;
  final double hookRadius;
  final Color hookColor;
  final HookPosition hookPosition;
  final double hookPadding;

  TriplePanel({
    this.controller,
    this.body,
    this.leftPanel,
    this.rightPanel,
    this.hookContentPadding,
    this.hookSize,
    this.hookChild,
    this.hookRadius,
    this.hookColor,
    this.hookPosition,
    this.hookPadding,
    this.leftHookChild,
    this.rightHookChild,
    this.leftPanelOpenState,
    this.rightPanelOpenState,
    this.leftPanelIsOpen,
    this.rightPanelIsOpen,
  });

  @override
  _TriplePanelState createState() => _TriplePanelState();
}

class _TriplePanelState extends State<TriplePanel> {
  TripleSidePanelController leftPanelController;
  TripleSidePanelController rightPanelController;
  bool leftPanelIsOpen;
  bool rightPanelIsOpen;

  @override
  void initState() {
    super.initState();
    leftPanelIsOpen = false;
    rightPanelIsOpen = false;

    leftPanelController = TripleSidePanelController();
    rightPanelController = TripleSidePanelController();

    leftPanelController.addListener((isOpen) {
      widget?.leftPanelOpenState(isOpen);
    });

    rightPanelController.addListener((isOpen) {
      widget?.rightPanelOpenState(isOpen);
    });

    widget.controller.closeLeftPanelCallback = leftPanelController.close;
    widget.controller.closeRightPanelCallback = rightPanelController.close;
    widget.controller.openLeftPanelCallback = leftPanelController.open;
    widget.controller.openRightPanelCallback = rightPanelController.open;
  }

  @override
  void didUpdateWidget(TriplePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leftPanelIsOpen != widget.leftPanelIsOpen) {
      setState(() {
        leftPanelIsOpen = widget.leftPanelIsOpen;
      });
    }
    if (oldWidget.rightPanelIsOpen != widget.rightPanelIsOpen) {
      setState(() {
        rightPanelIsOpen = widget.rightPanelIsOpen;
      });
    }
  }

  TripleSidePanel panel(bool isLeft, Widget child, Widget hookChild) {
    return TripleSidePanel(
      child: child,
      controller: isLeft ? leftPanelController : rightPanelController,
      side: isLeft ? TripleSidePanelSide.Left : TripleSidePanelSide.Right,
      isOpen: isLeft ? leftPanelIsOpen : rightPanelIsOpen,
      hookPosition: widget.hookPosition,
      hookPadding: widget.hookPadding,
      hookSize: widget.hookSize,
      hookRadius: widget.hookRadius,
      hookColor: widget.hookColor,
      hookChild: Padding(
        padding: widget.hookContentPadding ?? EdgeInsets.only(left: 15, right: 15),
        child: hookChild,
      ),
    );
  }

  List<TripleSidePanel> panels() {
    var panelsList = List<TripleSidePanel>();
    if (widget.leftPanel != null) {
      panelsList.add(panel(true, widget.leftPanel, widget.leftHookChild));
    }

    if (widget.rightPanel != null) {
      panelsList.add(panel(false, widget.rightPanel, widget.rightHookChild));
    }
    return panelsList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        this.widget.body,
      ]..addAll(panels()),
    );
  }

  @override
  void dispose() {
    leftPanelController.dispose();
    rightPanelController.dispose();
    super.dispose();
  }
}
