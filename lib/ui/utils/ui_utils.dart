import 'package:flutter/material.dart';
import 'package:nevada/services/dtos/snackbar_message.dart';

class UiUtils {

  Color _getColor(MessageType messageType, ColorScheme colorScheme) {
    switch (messageType) {
      case MessageType.info:
        return colorScheme.primary;
      case MessageType.success:
        return Colors.green;
      case MessageType.warning:
        return Colors.orangeAccent;
      case MessageType.error:
        return Colors.redAccent;
    }
  }

  void showSnackBar(BuildContext context, SnackbarMessage snackbarMessage) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: 70,
            decoration: BoxDecoration(
              color: _getColor(snackbarMessage.messageType, colorScheme),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snackbarMessage.title, style: textTheme.titleLarge?.copyWith(color: Colors.white)),
                      Text(
                        snackbarMessage.message,
                        style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 25,
              left: 20,
              child: ClipRRect(
                child: Stack(
                  children: const [
                    Icon(
                      Icons.circle,
                      color: Colors.deepOrange,
                      size: 17,
                    )
                  ],
                ),
              )),
          Positioned(
              top: -20,
              left: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  const Positioned(
                      top: 5,
                      child: Icon(
                        Icons.clear_outlined,
                        color: Colors.white,
                        size: 20,
                      ))
                ],
              )),
        ],
      ),
    ));
  }
}