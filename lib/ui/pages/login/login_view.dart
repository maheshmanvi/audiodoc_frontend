import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/login/login_controller.dart';
import 'package:audiodoc/ui/pages/login/login_validator.dart';
import 'package:audiodoc/ui/widgets/branding/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.primaryTint90,
      body: _Body(),
    );
  }
}

class _Body extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: controller.formKey,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: context.theme.colors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: BrandLogo(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Login to your account',
                          style: context.theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your email and password to login',
                          style: context.theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _EmailField(controller: controller),
                        const SizedBox(height: 48),
                        _PasswordField(controller: controller),
                        SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: () {
                            controller.login();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login'),
                              const SizedBox(width: 12),
                              Icon(Icons.login),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: context.theme.colors.primary,
                            foregroundColor: context.theme.colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final LoginController controller;

  const _EmailField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.emailEC,
      style: context.theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: _InputIcon(icon: Icons.email_outlined),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: context.theme.textTheme.bodySmall,
        hintStyle: context.theme.textTheme.bodySmall,
        labelStyle: context.theme.textTheme.bodyMedium,
        border: _LoginInputDecorationUtil.inputBorder(context),
        enabledBorder: _LoginInputDecorationUtil.inputBorder(context),
        focusedBorder: _LoginInputDecorationUtil.focusedInputBorder(context),
      ),
      validator: (value) => LoginValidator.validateEmail(value),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final LoginController controller;
  final RxBool obscureText = RxBool(true);

  _PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller.passwordEC,
        style: context.theme.textTheme.bodyMedium,
        obscureText: obscureText.value,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: context.theme.textTheme.bodySmall,
          hintStyle: context.theme.textTheme.bodySmall,
          prefixIcon: _InputIcon(icon: Icons.lock_outline),
          labelStyle: context.theme.textTheme.bodyMedium,
          border: _LoginInputDecorationUtil.inputBorder(context),
          enabledBorder: _LoginInputDecorationUtil.inputBorder(context),
          focusedBorder: _LoginInputDecorationUtil.focusedInputBorder(context),
          suffixIcon: InkWell(
            onTap: () {
              obscureText.value = !obscureText.value;
            },
            child: Obx(
              () => Icon(
                obscureText.value ? Icons.visibility : Icons.visibility_off,
                size: 18,
                color: context.theme.colors.primary,
              ),
            ),
          ),
        ),
        validator: (value) => LoginValidator.validatePassword(value),
      ),
    );
  }
}

class _InputIcon extends StatelessWidget {
  final IconData icon;

  const _InputIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 18,
      color: context.theme.colors.contentTertiary,
    );
  }
}

class _LoginInputDecorationUtil {
  static OutlineInputBorder inputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: context.theme.colors.loginFormFieldBorder,
        width: 1,
      ),
    );
  }

  static OutlineInputBorder focusedInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: context.theme.colors.primary,
        width: 2,
      ),
    );
  }
}
