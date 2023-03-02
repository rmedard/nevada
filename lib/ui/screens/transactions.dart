import 'package:flutter/material.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return ScreenElements().defaultBodyFrame(
        context: context, 
        title: 'Transactions',
        actions: Row(
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_downward),
              label: const Text('Nouvelle Dépense'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.error,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(width: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Nouvelle Entrée'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
        body: Text('data here...'));
  }
}
