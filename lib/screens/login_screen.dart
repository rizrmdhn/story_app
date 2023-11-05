import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final Function() onRegister;

  const LoginScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.15),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Column(
                          // the children should be aligned to the center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // the title
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // the Email field
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            // the password field
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // the login button
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                onPressed: () async {
                                  widget.onLogin(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                },
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // the sign up button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account?'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextButton(
                                    onPressed: () => widget.onRegister(),
                                    child: const Text('Sign up'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.15),
                    child: SingleChildScrollView(
                      child: Column(
                        // the children should be aligned to the center
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // the title
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the Email field
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          // the password field
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the login button
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onLogin(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the sign up button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account?'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextButton(
                                  onPressed: () => widget.onRegister(),
                                  child: const Text('Sign up'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
