import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/social/presentation/screens/author_profile_screen.dart';
import 'package:newsly/injection_container.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticlesEvent()),
      child: _ArticleDetailView(article: article),
    );
  }
}

class _ArticleDetailView extends StatelessWidget {
  final ArticleEntity article;

  const _ArticleDetailView({required this.article});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.thumbnailURL,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: scaffoldBg),
                errorWidget: (context, url, error) => Container(
                  color: scaffoldBg,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: cs.onSurface.withValues(alpha: 0.4)),
                ),
              ),
            ),
            actions: [
              BlocBuilder<LocalArticleBloc, LocalArticleState>(
                builder: (context, state) {
                  final isSaved = state is LocalArticlesLoaded &&
                      state.articles.any((a) => a.id == article.id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppTheme.accent : cs.onSurface,
                    ),
                    onPressed: () {
                      if (isSaved) {
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
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article.category!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 16,
                          color: cs.onSurface.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AuthBloc>(),
                              child: AuthorProfileScreen(
                                authorId: article.authorId,
                                authorName: article.author,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          article.author,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_outlined,
                          size: 14,
                          color: cs.onSurface.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(article.publishedAt),
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
