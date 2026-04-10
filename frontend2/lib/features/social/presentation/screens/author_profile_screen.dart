import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/social/presentation/bloc/social_bloc.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class AuthorProfileScreen extends StatelessWidget {
  final String authorId;
  final String authorName;

  const AuthorProfileScreen({
    super.key,
    required this.authorId,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthBloc>().state;
        final currentUserId =
            authState is AuthAuthenticated ? authState.user.id : '';
        return sl<SocialBloc>()
          ..add(CheckFollowEvent(
            followerId: currentUserId,
            followingId: authorId,
          ));
      },
      child: _AuthorProfileView(authorId: authorId, authorName: authorName),
    );
  }
}

class _AuthorProfileView extends StatelessWidget {
  final String authorId;
  final String authorName;

  const _AuthorProfileView({required this.authorId, required this.authorName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final authState = context.watch<AuthBloc>().state;
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : '';
    final isOwnProfile = currentUserId == authorId;
    final isAuthenticated = authState is AuthAuthenticated;

    return Scaffold(
      appBar: AppBar(title: Text(authorName)),
      body: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          final isFollowing =
              state is FollowState ? state.isFollowing : false;
          final followerCount =
              state is FollowState ? state.followerCount : 0;
          final isLoading = state is SocialLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Author header ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  color: cs.surface,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.primary,
                        child: Text(
                          authorName.isNotEmpty
                              ? authorName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$followerCount ${l10n.followers}',
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!isOwnProfile && isAuthenticated)
                        SizedBox(
                          width: 160,
                          child: isLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                )
                              : OutlinedButton.icon(
                                  onPressed: () {
                                    context.read<SocialBloc>().add(
                                          ToggleFollowEvent(
                                            followerId: currentUserId,
                                            followingId: authorId,
                                          ),
                                        );
                                  },
                                  icon: Icon(
                                    isFollowing
                                        ? Icons.person_remove_outlined
                                        : Icons.person_add_outlined,
                                    size: 18,
                                    color: isFollowing
                                        ? cs.onSurface.withValues(alpha: 0.6)
                                        : AppTheme.accent,
                                  ),
                                  label: Text(
                                    isFollowing
                                        ? l10n.unfollow
                                        : l10n.follow,
                                    style: TextStyle(
                                      color: isFollowing
                                          ? cs.onSurface.withValues(alpha: 0.6)
                                          : AppTheme.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: isFollowing
                                          ? cs.onSurface.withValues(alpha: 0.3)
                                          : AppTheme.accent,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
