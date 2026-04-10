import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/entities/comment_entity.dart';
import 'package:newsly/features/articles/presentation/bloc/interaction/interaction_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/social/presentation/screens/author_profile_screen.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<LocalArticleBloc>()..add(const GetSavedArticlesEvent()),
        ),
        BlocProvider(
          create: (_) {
            final authState = context.read<AuthBloc>().state;
            final userId = authState is AuthAuthenticated
                ? authState.user.id
                : '';
            return sl<InteractionBloc>()
              ..add(LoadInteractionsEvent(
                articleId: article.id,
                userId: userId,
                authorId: article.authorId,
              ));
          },
        ),
      ],
      child: _ArticleDetailView(article: article),
    );
  }
}

class _ArticleDetailView extends StatefulWidget {
  final ArticleEntity article;

  const _ArticleDetailView({required this.article});

  @override
  State<_ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<_ArticleDetailView> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitComment(String userId, String displayName) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    context.read<InteractionBloc>().add(AddCommentEvent(
          articleId: widget.article.id,
          authorId: userId,
          author: displayName,
          content: text,
        ));
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final authState = context.watch<AuthBloc>().state;
    final authed = authState is AuthAuthenticated ? authState : null;
    final isAuthenticated = authed != null;
    final currentUserId = authed?.user.id ?? '';
    final currentUserName = authed?.user.displayName ?? '';

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.article.thumbnailURL,
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
                      state.articles.any((a) => a.id == widget.article.id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppTheme.accent : cs.onSurface,
                    ),
                    onPressed: () {
                      if (isSaved) {
                        context
                            .read<LocalArticleBloc>()
                            .add(RemoveSavedArticleEvent(widget.article.id));
                      } else {
                        context
                            .read<LocalArticleBloc>()
                            .add(SaveArticleEvent(widget.article));
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
                  if (widget.article.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.article.category!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    widget.article.title,
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
                                authorId: widget.article.authorId,
                                authorName: widget.article.author,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          widget.article.author,
                          style: const TextStyle(
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
                        DateFormat('MMM d, yyyy')
                            .format(widget.article.publishedAt),
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ── Like bar ──────────────────────────────────────────────
                  BlocBuilder<InteractionBloc, InteractionState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: isAuthenticated
                                ? () => context
                                    .read<InteractionBloc>()
                                    .add(ToggleLikeEvent(
                                      articleId: widget.article.id,
                                      userId: currentUserId,
                                    ))
                                : null,
                            child: Row(
                              children: [
                                Icon(
                                  state.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 22,
                                  color: state.isLiked
                                      ? Colors.red
                                      : cs.onSurface.withValues(alpha: 0.5),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${state.likesCount} ${l10n.likes}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: cs.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(Icons.chat_bubble_outline,
                              size: 20,
                              color: cs.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 6),
                          Text(
                            '${state.comments.length} ${l10n.comments}',
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(Icons.visibility_outlined,
                              size: 20,
                              color: cs.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 6),
                          Text(
                            '${state.viewCount} ${l10n.views}',
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 32),
                  Text(
                    widget.article.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.article.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // ── Comments section ──────────────────────────────────────
                  Text(
                    l10n.comments,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Add comment input (authenticated only)
                  if (isAuthenticated)
                    _CommentInput(
                      controller: _commentController,
                      l10n: l10n,
                      cs: cs,
                      onSend: () =>
                          _submitComment(currentUserId, currentUserName),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        l10n.signInToComment,
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  BlocBuilder<InteractionBloc, InteractionState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (state.comments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.noComments,
                            style: TextStyle(
                              fontSize: 14,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: state.comments
                            .map((c) => _CommentTile(
                                  comment: c,
                                  currentUserId: currentUserId,
                                  articleId: widget.article.id,
                                  l10n: l10n,
                                ))
                            .toList(),
                      );
                    },
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

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final AppLocalizations l10n;
  final ColorScheme cs;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.l10n,
    required this.cs,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractionBloc, InteractionState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: l10n.addCommentHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            state.isSendingComment
                ? const SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: onSend,
                    icon: const Icon(Icons.send_rounded),
                    color: AppTheme.accent,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppTheme.accent.withValues(alpha: 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentEntity comment;
  final String currentUserId;
  final String articleId;
  final AppLocalizations l10n;

  const _CommentTile({
    required this.comment,
    required this.currentUserId,
    required this.articleId,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isOwner = comment.authorId == currentUserId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accent.withValues(alpha: 0.15),
            child: Text(
              comment.author.isNotEmpty
                  ? comment.author[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.author,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM d, HH:mm').format(comment.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _confirmDelete(context),
                          child: Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteComment),
        content: Text(l10n.deleteCommentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<InteractionBloc>().add(DeleteCommentEvent(
                    articleId: articleId,
                    commentId: comment.id,
                  ));
            },
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
