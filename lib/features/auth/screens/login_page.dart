import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  LoginPage({super.key});

  Future<void> _onLoginPressed(context) async {

    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<AppStateNotifier>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      String? result = await AuthService().login(_email!, _password!);
      if (result != null) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 64,),
                Text(
                  "Log in",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
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
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => _onLoginPressed(context),
                      child: Text("Log in")),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/auth/signup');
                      },
                      child: Text(
                        "Sign up",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
