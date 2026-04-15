import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/auth/auth_service.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';
import '../../../shared/widgets/parchment_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });

    try {
      await const AuthService().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        displayName: _usernameController.text.trim(),
      );
      setState(() => _success = true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text('Questify', style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              Text('Begin Your Legend', style: AppTextStyles.italic),
              const SizedBox(height: 48),
              ParchmentCard(
                padding: const EdgeInsets.all(24),
                margin: EdgeInsets.zero,
                child: _success
                    ? _SuccessView(onLogin: () => context.go('/auth/login'))
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create Your Character', style: AppTextStyles.displayMedium),
                            const SizedBox(height: 6),
                            Text('Choose your adventurer name wisely', style: AppTextStyles.italic),
                            const SizedBox(height: 24),
                            ParchmentTextField(
                              controller: _usernameController,
                              label: 'Adventurer Name',
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            ParchmentTextField(
                              controller: _emailController,
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            ParchmentTextField(
                              controller: _passwordController,
                              label: 'Password',
                              obscureText: true,
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'At least 6 characters'
                                  : null,
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _error!,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.waxRed),
                              ),
                            ],
                            const SizedBox(height: 24),
                            DndButton(
                              label: 'Begin Your Legend',
                              onPressed: _signUp,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              if (!_success)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already an adventurer? ', style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => context.go('/auth/login'),
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.royalBlue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.royalBlue,
                        ),
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

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.forestGreen, size: 56),
        const SizedBox(height: 16),
        Text('Character Created!', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Check your email to confirm your account, then sign in to begin your adventure.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        DndButton(label: 'Sign In', onPressed: onLogin),
      ],
    );
  }
}
