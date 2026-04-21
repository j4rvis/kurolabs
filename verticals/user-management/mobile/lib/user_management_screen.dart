import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _profileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final res = await supabaseClient
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();
  return res as Map<String, dynamic>;
});

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _editing = false;
  bool _saving = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _startEditing(Map<String, dynamic> profile) {
    _displayNameController.text = profile['display_name'] as String? ?? '';
    _usernameController.text = profile['username'] as String;
    setState(() {
      _editing = true;
      _error = null;
      _success = false;
    });
  }

  Future<void> _save(String userId) async {
    setState(() {
      _saving = true;
      _error = null;
      _success = false;
    });

    try {
      await supabaseClient.from('profiles').update({
        'display_name': _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
        'username': _usernameController.text.trim(),
      }).eq('id', userId);

      if (mounted) {
        setState(() {
          _saving = false;
          _editing = false;
          _success = true;
        });
        ref.invalidate(_profileProvider);
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.code == '23505'
              ? 'That username is already taken.'
              : e.message;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await supabaseClient.auth.signOut();
    // Auth state change triggers router redirect to /auth/login
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(_profileProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: profile['avatar_url'] != null
                          ? NetworkImage(profile['avatar_url'] as String)
                          : null,
                      child: profile['avatar_url'] == null
                          ? const Text('⚔️', style: TextStyle(fontSize: 24))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (profile['display_name'] as String?) ??
                                (profile['username'] as String),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '@${profile['username']}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            profile['character_class'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (_success)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Profile updated.',
                      style: TextStyle(color: Colors.green[400]),
                    ),
                  ),

                if (!_editing) ...[
                  OutlinedButton(
                    onPressed: () => _startEditing(profile),
                    child: const Text('Edit Profile'),
                  ),
                ] else ...[
                  // Edit form
                  TextField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saving ? null : () => _save(user!.id),
                        child:
                            Text(_saving ? 'Saving…' : 'Save Changes'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () =>
                            setState(() => _editing = false),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: _signOut,
                  child: const Text('Sign out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
