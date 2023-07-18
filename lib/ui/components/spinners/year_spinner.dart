import 'package:flutter/material.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class YearSpinner extends StatefulWidget {
  final int initialYear;
  final Function(int year) onChanged;

  const YearSpinner({super.key, required this.initialYear, required this.onChanged});

  @override
  State<YearSpinner> createState() => _YearSpinnerState();
}

class _YearSpinnerState extends State<YearSpinner> {
  late int selectedYear;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    _inputController.text = '${widget.initialYear}';
    _inputController.addListener(() => widget.onChanged(selectedYear));
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
        child: TextField(
            controller: _inputController,
            textAlign: TextAlign.center,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () => setState(() => _inputController.text = '${--selectedYear}'),
                    icon: const Icon(Nevada.back, size: 18)),
                suffixIcon: IconButton(
                    onPressed: () => setState(() => _inputController.text = '${++selectedYear}'),
                    icon: const Icon(Nevada.forward, size: 18)))));
  }
}
