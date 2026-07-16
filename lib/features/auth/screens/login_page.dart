import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email;

  String? _password;

  bool _loading = false;

  Future<void> _onLoginPressed(context) async {

    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<AppStateNotifier>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      String? result = await AuthService().login(_email!, _password!);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Join household",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    64.gapHeight,
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await context.push("/auth/qrScanner");

                        if (result == true) {
                          Provider.of<AppStateNotifier>(context, listen: false).login();
                        }
                      },
                      icon: Icon(Icons.qr_code_scanner_rounded),
                      label: "Scan QR to join household".text(),
                    ),
                    Divider(height: 48,),
                    Text(
                      "Manually log in",
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
                          ? 'Please enter a email'
                          : null,
                      onChanged: (value) => _email = value,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a password'
                          : null,
                      onChanged: (value) => _password = value,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: !_loading ? () => _onLoginPressed(context) : null,
                          child: Text("Log in")),
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
