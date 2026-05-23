import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/google_sign_in_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreed = false;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _googleLoading = true);
    try {
      final profile = await AuthService.instance.signInWithGoogle();
      if (!mounted || profile == null) return;
      context.go(AuthService.instance.postAuthRoute);
    } catch (e) {
      if (mounted) _showError(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Tüm alanları doldurun.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(
        name: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      context.go(AuthService.instance.postAuthRoute);
    } catch (e) {
      if (mounted) _showError(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kayıt Ol'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              AppTextField(
                hint: 'Adınız',
                icon: Icons.person_outline_rounded,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'E-posta adresiniz',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Şifreniz (en az 6 karakter)',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    side: const BorderSide(color: AppColors.divider),
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.textPrimary, fontSize: 14),
                        children: const [
                          TextSpan(text: 'NeuralMedics '),
                          TextSpan(
                            text: 'Kullanım Koşulları',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ' ve '),
                          TextSpan(
                            text: 'Gizlilik Politikası',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: 'nı kabul ediyorum.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (_agreed && !_loading && !_googleLoading)
                    ? _submit
                    : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.4),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Kayıt Ol'),
              ),
              const AuthOrDivider(),
              GoogleSignInButton(
                loading: _googleLoading,
                onPressed: (_loading || _googleLoading)
                    ? null
                    : _signInWithGoogle,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Zaten hesabınız var mı? ',
                      style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
