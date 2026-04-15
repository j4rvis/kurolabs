import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/auth/auth_service.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';
import '../../../shared/widgets/parchment_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });

    try {
      await const AuthService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Router redirect handles navigation
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
              // Title scroll
              Text('Questify', style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              Text(
                'Your Adventure Awaits',
                style: AppTextStyles.italic,
              ),
              const SizedBox(height: 48),
              ParchmentCard(
                padding: const EdgeInsets.all(24),
                margin: EdgeInsets.zero,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter the Tavern', style: AppTextStyles.displayMedium),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to continue your quest log',
                        style: AppTextStyles.italic,
                      ),
                      const SizedBox(height: 24),
                      ParchmentTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.waxRed,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      DndButton(
                        label: 'Begin Adventure',
                        onPressed: _signIn,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New adventurer? ', style: AppTextStyles.bodyMedium),
                  GestureDetector(
                    onTap: () => context.go('/auth/signup'),
                    child: Text(
                      'Create Account',
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

