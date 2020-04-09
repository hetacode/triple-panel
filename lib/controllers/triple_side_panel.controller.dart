class TripleSidePanelController {
  Function openCallback;
  Function closeCallback;

  Function(bool isOpen) callback;
  void addListener(Function(bool) isOpenCallback) {
    this.callback = callback;
  }

  void open() {
    if (openCallback != null) {
      openCallback();
    }
  }

  void close() {
    if (closeCallback != null) {
      closeCallback();
    }
  }

  void dispose() {
    callback = null;
    openCallback = null;
    closeCallback = null;
  }
}
