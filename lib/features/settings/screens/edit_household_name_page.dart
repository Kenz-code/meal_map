import 'package:flutter/material.dart';
import 'package:meal_map/core/services/device_service.dart';
import 'package:meal_map/core/services/user_firestore_manager_service.dart';

class EditHouseholdNamePage extends StatefulWidget {
  const EditHouseholdNamePage({
    super.key,
  });

  @override
  State<EditHouseholdNamePage> createState() => _EditHouseholdNamePageState();
}

class _EditHouseholdNamePageState extends State<EditHouseholdNamePage> {
  final _controller = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadHouseholdName();
  }

  Future<void> _loadHouseholdName() async {
    final name = await UserFirestoreManagerService.instance.getHouseholdName();

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
          content: Text("Household name cannot be empty"),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await UserFirestoreManagerService.instance.setHouseholdName(name);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to rename household"),
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
        title: const Text("Edit household name"),
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
                labelText: "Household name",
                hintText: "Example: John Doe's Kitchen",
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