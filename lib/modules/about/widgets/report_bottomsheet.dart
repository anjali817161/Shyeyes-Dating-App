import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReportReasonBottomSheet extends StatefulWidget {
  final Function(List<String>) onReasonSelected;
  const ReportReasonBottomSheet({super.key, required this.onReasonSelected});

  @override
  State<ReportReasonBottomSheet> createState() =>
      _ReportReasonBottomSheetState();
}

class _ReportReasonBottomSheetState extends State<ReportReasonBottomSheet> {
  final List<String> _reasons = [
    "Fake profile",
    "Offensive content",
    "Harassment",
    "Other",
  ];
  final List<String> _selectedReasons = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Text(
                    "Select reason(s) to report",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Multiple checkboxes
            ..._reasons.map((reason) {
              return CheckboxListTile(
                value: _selectedReasons.contains(reason),
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedReasons.add(reason);
                    } else {
                      _selectedReasons.remove(reason);
                    }
                  });
                },
                title: Text(
                  reason,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                activeColor: theme.colorScheme.primary,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            }),

            const SizedBox(height: 12),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedReasons.isNotEmpty
                      ? theme.colorScheme.primary
                      : theme.disabledColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _selectedReasons.isNotEmpty
                    ? () {
                        widget.onReasonSelected(_selectedReasons);
                        Navigator.pop(context);
                        Get.back();
                      }
                    : null,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: _selectedReasons.isNotEmpty
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
