import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/api_service.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';

class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });

    try {
      await ApiService.post(
        '/api/quest-givers',
        {'giver_email': _emailController.text.trim()},
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
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('Invite Quest Giver', style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _success
            ? _SuccessView(onDone: () => context.pop())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParchmentCard(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summon a Quest Giver', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Enter the email of the person you wish to grant quest-giving powers.',
                            style: AppTextStyles.italic,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            style: AppTextStyles.bodyMedium,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              filled: true,
                              fillColor: AppColors.parchmentDark,
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.waxRed)),
                          ],
                          const SizedBox(height: 20),
                          DndButton(
                            label: 'Send Invitation',
                            onPressed: _invite,
                            isLoading: _isLoading,
                            icon: Icons.send,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.forestGreen, size: 64),
        const SizedBox(height: 16),
        Text('Invitation Sent!', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Your quest giver has been summoned. They will receive an invitation to join your adventure.',
          style: AppTextStyles.italic,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        DndButton(label: 'Return', onPressed: onDone),
      ],
    );
  }
}
