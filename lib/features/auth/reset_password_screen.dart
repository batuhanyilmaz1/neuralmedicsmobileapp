import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _emailController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('E-posta adresinizi girin.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.sendPasswordResetEmail(email);
      if (mounted) _showSentDialog(email);
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

  void _showSentDialog(String email) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mark_email_read_outlined,
                  size: 48, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'E-postanızı kontrol edin',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$email adresine şifre sıfırlama bağlantısı gönderildi. '
                'Gelen kutunuzu ve spam klasörünü kontrol edin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.45),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (AuthService.instance.isLoggedIn) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.login);
                    }
                  },
                  child: const Text('Tamam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromProfile = AuthService.instance.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Şifre Sıfırla'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                fromProfile
                    ? 'Hesabınıza bağlı e-posta adresine şifre sıfırlama bağlantısı gönderilecek.'
                    : 'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),
              AppTextField(
                hint: 'E-posta adresiniz',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                readOnly: fromProfile && widget.initialEmail != null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _loading ? null : _sendReset,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Sıfırlama Bağlantısı Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
