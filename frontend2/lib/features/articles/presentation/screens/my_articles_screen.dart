import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';
import 'package:newsly/features/articles/presentation/widgets/article_tile.dart';
import 'package:newsly/injection_container.dart';

class MyArticlesScreen extends StatelessWidget {
  const MyArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<LocalArticleBloc>()..add(const GetSavedArticlesEvent()),
      child: const _MyArticlesView(),
    );
  }
}

class _MyArticlesView extends StatelessWidget {
  const _MyArticlesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.uploadArticle),
            tooltip: 'Write Article',
          ),
        ],
      ),
      body: BlocBuilder<LocalArticleBloc, LocalArticleState>(
        builder: (context, state) {
          if (state is LocalArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LocalArticleError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }

          if (state is LocalArticlesLoaded) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border,
                        size: 64, color: AppTheme.textSecondary),
                    SizedBox(height: 16),
                    Text(
                      'No saved articles yet.\nBookmark articles to read them later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 16),
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
                  isSaved: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.articleDetail,
                    arguments: article,
                  ),
                  onSave: () => context
                      .read<LocalArticleBloc>()
                      .add(RemoveSavedArticleEvent(article.id)),
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
