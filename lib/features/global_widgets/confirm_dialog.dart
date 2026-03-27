import 'package:exui/exui.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final Text title;
  final Text content;
  final String confirmLabel;
  final Future<void> Function() onConfirm;

  const ConfirmDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmLabel = 'Confirm',
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            await widget.onConfirm();
            Navigator.pop(context, true);
          },
          child: _isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(widget.confirmLabel),
        ),
      ],
    );
  }
}