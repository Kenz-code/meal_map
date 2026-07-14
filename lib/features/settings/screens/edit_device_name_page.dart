import 'package:flutter/material.dart';
import 'package:meal_map/core/services/device_service.dart';

class EditDeviceNamePage extends StatefulWidget {
  const EditDeviceNamePage({
    super.key,
  });

  @override
  State<EditDeviceNamePage> createState() => _EditDeviceNamePageState();
}

class _EditDeviceNamePageState extends State<EditDeviceNamePage> {
  final _controller = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceName();
  }

  Future<void> _loadDeviceName() async {
    final name = await DeviceService.instance.getCurrentDeviceName();

    if (!mounted) return;

    setState(() {
      _controller.text = name;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Device name cannot be empty"),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await DeviceService.instance.renameCurrentDevice(name);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to rename device"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit device name"),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: "Device name",
                hintText: "Example: Kitchen Tablet",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _save(),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}