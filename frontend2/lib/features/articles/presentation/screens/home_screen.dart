import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/config/theme/theme_cubit.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_state.dart';
import 'package:newsly/core/services/analytics_service.dart';
import 'package:newsly/core/services/remote_config_service.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/presentation/widgets/article_card.dart';
import 'package:newsly/features/articles/presentation/widgets/article_tile.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/auth/presentation/screens/language_screen.dart';
import 'package:newsly/features/auth/presentation/screens/profile_screen.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RemoteArticleBloc>()..add(const GetPublishedArticlesEvent()),
        ),
        BlocProvider(
          create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticlesEvent()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _searchController = TextEditingController();
  String _query = '';
  late final String _cardStyle;

  @override
  void initState() {
    super.initState();
    _cardStyle = sl<RemoteConfigService>().articleCardStyle;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openArticle(BuildContext context, article) {
    sl<AnalyticsService>().logArticleOpened(
      articleId: article.id,
      category: article.category ?? '',
      cardStyle: _cardStyle,
    );
    Navigator.pushNamed(context, AppRoutes.articleDetail, arguments: article);
  }

  Widget _buildArticleTile({
    required ArticleEntity article,
    required BuildContext context,
    bool isSaved = false,
    VoidCallback? onSave,
  }) {
    if (_cardStyle == 'card') {
      return ArticleCard(
        article: article,
        onTap: () => _openArticle(context, article),
        isSaved: isSaved,
        onSave: onSave,
      );
    }
    return ArticleTile(
      article: article,
      onTap: () => _openArticle(context, article),
      isSaved: isSaved,
      onSave: onSave,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isGuest = context.watch<AuthBloc>().state is AuthGuest;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          if (isGuest)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.guestSettings,
              onPressed: () => _showGuestSettings(context, l10n),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.bookmark_outline),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.myArticles),
              tooltip: l10n.savedArticles,
            ),
            IconButton(
              icon: const Icon(Icons.newspaper_outlined),
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.myFirestoreArticles);
                if (context.mounted) {
                  context.read<RemoteArticleBloc>().add(const GetPublishedArticlesEvent());
                }
              },
              tooltip: l10n.myArticles,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.uploadArticle);
                if (context.mounted) {
                  context.read<RemoteArticleBloc>().add(const GetPublishedArticlesEvent());
                }
              },
              tooltip: l10n.writeArticle,
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: l10n.profile,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: const ProfileScreen(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (isGuest) _GuestBanner(l10n: l10n),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _query = '';
                          _searchController.clear();
                        }),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
              builder: (context, state) {
                if (state is RemoteArticleLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RemoteArticleError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppTheme.accent),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<RemoteArticleBloc>()
                              .add(const GetPublishedArticlesEvent()),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RemoteArticlesLoaded) {
                  final articles = _query.isEmpty
                      ? state.articles
                      : state.articles.where((a) {
                          return a.title.toLowerCase().contains(_query) ||
                              (a.category?.toLowerCase().contains(_query) ?? false) ||
                              a.author.toLowerCase().contains(_query);
                        }).toList();

                  if (articles.isEmpty) {
                    return Center(
                      child: Text(
                        _query.isEmpty ? l10n.noArticlesYet : l10n.noSearchResults,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.6), fontSize: 16),
                      ),
                    );
                  }

                  if (isGuest) {
                    return RefreshIndicator(
                      onRefresh: () async => context
                          .read<RemoteArticleBloc>()
                          .add(const GetPublishedArticlesEvent()),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: articles.length,
                        itemBuilder: (context, index) => _buildArticleTile(
                          article: articles[index],
                          context: context,
                        ),
                      ),
                    );
                  }

                  return BlocBuilder<LocalArticleBloc, LocalArticleState>(
                    builder: (context, localState) {
                      final savedIds = localState is LocalArticlesLoaded
                          ? localState.articles.map((a) => a.id).toSet()
                          : <String>{};

                      return RefreshIndicator(
                        onRefresh: () async => context
                            .read<RemoteArticleBloc>()
                            .add(const GetPublishedArticlesEvent()),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return _buildArticleTile(
                              article: article,
                              context: context,
                              isSaved: savedIds.contains(article.id),
                              onSave: () {
                                if (savedIds.contains(article.id)) {
                                  context.read<LocalArticleBloc>().add(
                                      RemoveSavedArticleEvent(article.id));
                                } else {
                                  context
                                      .read<LocalArticleBloc>()
                                      .add(SaveArticleEvent(article));
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showGuestSettings(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _GuestSettingsSheet(l10n: l10n),
    );
  }
}

class _GuestBanner extends StatelessWidget {
  final AppLocalizations l10n;
  const _GuestBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppTheme.accent.withValues(alpha: 0.08),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: AppTheme.accent.withValues(alpha: 0.8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.signInToInteract,
              style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.read<AuthBloc>().add(const SignOutEvent()),
            child: Text(
              l10n.guestBannerAction,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestSettingsSheet extends StatelessWidget {
  final AppLocalizations l10n;
  const _GuestSettingsSheet({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Dark mode toggle
          BlocBuilder<ThemeCubit, ThemeMode>(
            bloc: sl<ThemeCubit>(),
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                    color: cs.onSurface.withValues(alpha: 0.7)),
                title: Text(l10n.darkMode, style: TextStyle(color: cs.onSurface)),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => sl<ThemeCubit>().toggleTheme(),
                  activeThumbColor: AppTheme.accent,
                ),
                onTap: () => sl<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          // Language
          ListTile(
            leading: Icon(Icons.language_outlined, color: cs.onSurface.withValues(alpha: 0.7)),
            title: Text(l10n.language, style: TextStyle(color: cs.onSurface)),
            trailing: Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.4)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
