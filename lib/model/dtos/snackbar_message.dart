
enum MessageType {
  success, info, warning, error
}

class SnackbarMessage {
  MessageType messageType = MessageType.info;
  String title = '';
  String message = '';

  SnackbarMessage({required this.messageType, required this.title, required this.message});
}