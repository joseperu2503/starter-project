import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/config/theme/theme_cubit.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/auth/presentation/screens/change_password_screen.dart';
import 'package:newsly/features/auth/presentation/screens/personal_info_screen.dart';
import 'package:newsly/features/auth/presentation/screens/language_screen.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return ListView(
            children: [
              Container(
                color: cs.surface,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        user != null && user.displayName.isNotEmpty
                            ? user.displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _SectionHeader(title: l10n.account),
              _ProfileTile(
                icon: Icons.person_outline,
                title: l10n.personalInformation,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthBloc>(),
                      child: const PersonalInfoScreen(),
                    ),
                  ),
                ),
              ),
              _ProfileTile(
                icon: Icons.lock_outline,
                title: l10n.changePassword,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthBloc>(),
                      child: const ChangePasswordScreen(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _SectionHeader(title: l10n.preferences),
              BlocBuilder<ThemeCubit, ThemeMode>(
                bloc: sl<ThemeCubit>(),
                builder: (context, themeMode) {
                  final isDark = themeMode == ThemeMode.dark;
                  return _ProfileTile(
                    icon: isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                    title: l10n.darkMode,
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) => sl<ThemeCubit>().toggleTheme(),
                      activeThumbColor: AppTheme.accent,
                    ),
                    onTap: () => sl<ThemeCubit>().toggleTheme(),
                  );
                },
              ),
              _ProfileTile(
                icon: Icons.language_outlined,
                title: l10n.language,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
              ),

              const SizedBox(height: 8),

              _SectionHeader(title: l10n.session),
              _ProfileTile(
                icon: Icons.logout,
                title: l10n.signOut,
                titleColor: AppTheme.accent,
                iconColor: AppTheme.accent,
                onTap: () => _confirmSignOut(context, l10n),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signOut, style: const TextStyle(color: AppTheme.accent)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const SignOutEvent());
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cs.onSurface.withValues(alpha: 0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.titleColor,
    this.iconColor,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? cs.onSurface.withValues(alpha: 0.6), size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: titleColor ?? cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.4))
                : null),
        onTap: onTap,
      ),
    );
  }
}
