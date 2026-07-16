import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/shared_prefs_service.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {

  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email;

  String? _password;

  String? _householdName;

  bool _loading = false;

  Future<void> _onSignupPressed(context) async {
    final provider = Provider.of<AppStateNotifier>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      String? result = await AuthService().register(_email!, _password!, _householdName!);
      if (result != null) {

        setState(() {
          _loading = false;
        });

        messenger.showSnackBar(SnackBar(
          content: Text(
            result,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      } else {
        // ensure the user sees the app tutorial
        SharedPrefsService.instance.setBool('isFirstLaunch', true);

        provider.login();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded)
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Let's get started!",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    64.gapHeight,
                    Text(
                      "Create household",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your email'
                          : null,
                      onChanged: (value) => _email = value,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a password'
                          : null,
                      onChanged: (value) => _password = value,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Household name',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a household name'
                          : null,
                      onChanged: (value) => _householdName = value,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: !_loading ? () => _onSignupPressed(context) : null,
                          child: Text("Sign up")),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
