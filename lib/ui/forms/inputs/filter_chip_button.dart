import 'package:flutter/material.dart';

class FilterChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool value) onChipSelected;
  const FilterChipButton({Key? key, required this.label, required this.isSelected, required this.onChipSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return FilterChip(
        label: Text(label,
            style: textTheme.titleMedium?.copyWith(color: isSelected ? Colors.white : Colors.black87)),
        showCheckmark: true,
        backgroundColor: colorScheme.primary.withOpacity(0.2),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        padding: const EdgeInsets.all(8),
        selectedColor: colorScheme.primaryContainer,
        selected: isSelected,
        onSelected: onChipSelected);
  }
}
