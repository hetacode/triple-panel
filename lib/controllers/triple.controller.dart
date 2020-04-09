import 'package:triple_panel/components/side.panel.dart';
import 'package:triple_panel/triple_panel.dart';

class TriplePanelController {
  Function closeLeftPanelCallback;
  Function closeRightPanelCallback;
  Function openLeftPanelCallback;
  Function openRightPanelCallback;

  Function(bool) callback;
  TriplePanel widget;

  void addListener(Function(bool) isOpenCallback) {
    this.callback = callback;
  }

  void close(TripleSidePanelSide side) {
    switch (side) {
      case TripleSidePanelSide.Left:
        if (closeLeftPanelCallback != null) {
          closeLeftPanelCallback();
        }
        break;
      case TripleSidePanelSide.Right:
        if (closeRightPanelCallback != null) {
          closeRightPanelCallback();
        }
        break;
    }
  }

  void open(TripleSidePanelSide side) {
    switch (side) {
      case TripleSidePanelSide.Left:
        if (openLeftPanelCallback != null) {
          openLeftPanelCallback();
        }
        break;
      case TripleSidePanelSide.Right:
        if (openRightPanelCallback != null) {
          openRightPanelCallback();
        }
        break;
    }
  }

  void dispose() {
    closeLeftPanelCallback = null;
    closeRightPanelCallback = null;
    openLeftPanelCallback = null;
    openRightPanelCallback = null;

    callback = null;
    widget = null;
  }
}
