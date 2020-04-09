import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:triple_panel/controllers/triple_side_panel.controller.dart';

enum TripleSidePanelSide { Left, Right }
enum HookPosition { Top, Center, Bottom }

class TripleSidePanel extends StatefulWidget {
  final Widget child;
  final TripleSidePanelSide side;
  final TripleSidePanelController controller;
  final bool isOpen;

  final Size hookSize;
  final Widget hookChild;
  final double hookRadius;
  final Color hookColor;
  final HookPosition hookPosition;
  final double hookPadding;

  TripleSidePanel({
    this.child,
    this.side,
    this.isOpen,
    this.controller,
    this.hookSize,
    this.hookChild,
    this.hookRadius,
    this.hookColor,
    this.hookPosition,
    this.hookPadding,
  });

  @override
  _TripleSidePanelState createState() => _TripleSidePanelState();
}

class _TripleSidePanelState extends State<TripleSidePanel> with TickerProviderStateMixin {
  GlobalKey _rootKey = GlobalKey();
  double width = 0;
  double height = 0;
  double transPanelX = 0;
  double transButtonX = 0;

  AnimationController _panelAnimationController;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller.closeCallback = () => animateSliding(false);
      widget.controller.openCallback = () => animateSliding(true);
    }

    _panelAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((d) {
      var rootRenderObject = _rootKey.currentContext.findRenderObject();
      setState(() {
        width = rootRenderObject.semanticBounds.width;
        height = rootRenderObject.semanticBounds.height;

        transPanelX = (widget.isOpen ?? false)
            ? 0
            : rootRenderObject.semanticBounds.width;
        if (widget.isOpen ?? false) {
          transButtonX = widget.side == TripleSidePanelSide.Left ? width : -width;
        }
      });
    });
  }

  AlignmentGeometry hookPosition() {
    if (widget.side == TripleSidePanelSide.Left) {
      switch (widget.hookPosition ?? HookPosition.Center) {
        case HookPosition.Top:
          return Alignment.topLeft;
        case HookPosition.Center:
          return Alignment.centerLeft;
        case HookPosition.Bottom:
          return Alignment.bottomLeft;
      }
    } else {
      switch (widget.hookPosition ?? HookPosition.Center) {
        case HookPosition.Top:
          return Alignment.topRight;
        case HookPosition.Center:
          return Alignment.centerRight;
        case HookPosition.Bottom:
          return Alignment.bottomRight;
      }
    }

    return Alignment.centerLeft;
  }

  Widget leftButton() {
    return Transform.translate(
      offset: Offset(transButtonX, widget.hookPadding ?? 0),
      child: Align(
        alignment: hookPosition(),
        child: SizedBox(
          width: widget.hookSize?.width ?? 50,
          height: widget.hookSize?.height ?? 50,
          child: GestureDetector(
            onHorizontalDragUpdate: (v) {
              setState(() {
                double delta = v.delta.dx;
                transButtonX += delta;
                transPanelX -= delta;
              });
            },
            onHorizontalDragEnd: (v) {
              if (transButtonX.abs() > width / 2) {
                animateSliding(true);
              } else {
                animateSliding(
                    false); // if is half of screen width back to base state
              }
            },
            onTap: () {
              animateSliding(true);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(widget.hookRadius ?? 40),
                  bottomRight: Radius.circular(widget.hookRadius ?? 40),
                ),
                color: widget.hookColor ?? Colors.blue,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: widget.hookChild,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rightButton() {
    return Transform.translate(
      offset: Offset(transButtonX, widget.hookPadding ?? 0),
      child: Align(
        alignment: hookPosition(),
        child: SizedBox(
          width: widget.hookSize?.width ?? 50,
          height: widget.hookSize?.height ?? 50,
          child: GestureDetector(
            onHorizontalDragUpdate: (v) {
              setState(() {
                double delta = v.delta.dx;
                transButtonX += delta;
                transPanelX += delta;
              });
            },
            onHorizontalDragEnd: (v) {
              if (transButtonX.abs() > width / 2) {
                animateSliding(true);
              } else {
                animateSliding(
                    false); // if is half of screen width back to base state
              }
            },
            onTap: () {
              animateSliding(true);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.hookRadius ?? 40),
                  bottomLeft: Radius.circular(widget.hookRadius ?? 40),
                ),
                color: widget.hookColor ?? Colors.blue,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.hookChild,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animateSliding(bool continueSlide) {

    var tweenPanel =
        Tween<double>(begin: transPanelX, end: continueSlide ? 0 : width);
    var animation = tweenPanel.animate(_panelAnimationController);
    animation.addListener(() {
      setState(() {
        transPanelX = animation.value;
      });
    });
    var tweenButton = Tween<double>(
        begin: transButtonX,
        end: widget.side == TripleSidePanelSide.Left
            ? (continueSlide ? width : 0)
            : (continueSlide ? -width : 0));
    var animationButton = tweenButton.animate(_panelAnimationController);
    animationButton.addListener(() {
      setState(() {
        transButtonX = animationButton.value;
      });
    });
    _panelAnimationController.reset();
    _panelAnimationController.forward();

    if (widget.controller?.callback != null) {
      widget.controller?.callback(continueSlide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _rootKey,
      children: <Widget>[
        Transform.translate(
          offset: Offset(
              widget.side == TripleSidePanelSide.Left ? -transPanelX : transPanelX,
              0),
          child: SizedBox(
            width: width,
            height: height,
            child: this.widget.child,
          ),
        ),
        widget.side == TripleSidePanelSide.Left ? leftButton() : rightButton(),
      ],
    );
  }

  @override
  void dispose() {
    _panelAnimationController.dispose();
    super.dispose();
  }
}
