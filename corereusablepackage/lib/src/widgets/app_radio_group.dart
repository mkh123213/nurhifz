import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppRadioGroup<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;
  final Axis direction;

  const AppRadioGroup({
    super.key,
    this.label,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.value,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) {
      final selected = value == item;
      return GestureDetector(
        onTap: () => onChanged(item),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            Flexible(
              child: Text(
                labelBuilder(item),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        if (direction == Axis.vertical)
          ...children
        else
          Wrap(spacing: 8, children: children),
      ],
    );
  }
}
