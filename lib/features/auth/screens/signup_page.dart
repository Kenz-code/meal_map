import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  SignupPage({super.key});

  Future<void> _onSignupPressed(context) async {
    if (_formKey.currentState!.validate()) {
      String? result = await AuthService().register(_email!, _password!);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        GoRouter.of(context).go("/meals");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign up",
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
                      onPressed: () => _onSignupPressed(context),
                      child: Text("Sign up")),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/auth/login');
                      },
                      child: Text(
                        "Log in",
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
