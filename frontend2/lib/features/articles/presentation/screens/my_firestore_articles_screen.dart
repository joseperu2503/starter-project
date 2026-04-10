import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_state.dart';
import 'package:newsly/features/articles/presentation/widgets/article_tile.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class MyFirestoreArticlesScreen extends StatelessWidget {
  const MyFirestoreArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final authorId = authState is AuthAuthenticated ? authState.user.id : '';

    return BlocProvider(
      create: (_) => sl<RemoteArticleBloc>()..add(GetMyArticlesEvent(authorId)),
      child: _MyFirestoreArticlesView(authorId: authorId),
    );
  }
}

class _MyFirestoreArticlesView extends StatelessWidget {
  final String authorId;
  const _MyFirestoreArticlesView({required this.authorId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myArticlesTitle)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.uploadArticle);
          if (context.mounted) {
            context.read<RemoteArticleBloc>().add(GetMyArticlesEvent(authorId));
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
        builder: (context, state) {
          if (state is RemoteArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RemoteArticleError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
              ),
            );
          }

          if (state is RemoteArticlesLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 64, color: cs.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noMyArticles,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return ArticleTile(
                  article: article,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.articleDetail,
                    arguments: article,
                  ),
                  onSave: null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: cs.onSurface.withValues(alpha: 0.6)),
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.uploadArticle,
                            arguments: article,
                          );
                          if (context.mounted) {
                            context.read<RemoteArticleBloc>().add(GetMyArticlesEvent(authorId));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.accent),
                        onPressed: () => _confirmDelete(context, article.id, article.thumbnailPath, l10n),
                      ),
                    ],
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

  Future<void> _confirmDelete(
    BuildContext context,
    String articleId,
    String thumbnailPath,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteArticle),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete, style: const TextStyle(color: AppTheme.accent)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<RemoteArticleBloc>().add(DeleteArticleEvent(
            articleId: articleId,
            thumbnailPath: thumbnailPath,
          ));
    }
  }
}
