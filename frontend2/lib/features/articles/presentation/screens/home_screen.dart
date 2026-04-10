import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_state.dart';
import 'package:newsly/features/articles/presentation/widgets/article_tile.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
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

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
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
      ),
      body: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
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
            if (state.articles.isEmpty) {
              return Center(
                child: Text(
                  l10n.noArticlesYet,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 16),
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
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return ArticleTile(
                        article: article,
                        isSaved: savedIds.contains(article.id),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.articleDetail,
                          arguments: article,
                        ),
                        onSave: () {
                          if (savedIds.contains(article.id)) {
                            context
                                .read<LocalArticleBloc>()
                                .add(RemoveSavedArticleEvent(article.id));
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
    );
  }
}
