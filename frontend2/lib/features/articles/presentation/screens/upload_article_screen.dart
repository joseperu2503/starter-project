import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/articles/data/data_sources/remote/firestore_category_data_source.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_state.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class UploadArticleScreen extends StatelessWidget {
  final ArticleEntity? article;

  const UploadArticleScreen({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RemoteArticleBloc>(),
      child: _UploadArticleView(article: article),
    );
  }
}

class _UploadArticleView extends StatefulWidget {
  final ArticleEntity? article;

  const _UploadArticleView({this.article});

  @override
  State<_UploadArticleView> createState() => _UploadArticleViewState();
}

class _UploadArticleViewState extends State<_UploadArticleView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();

  File? _thumbnail;
  bool _isPublished = true;
  String? _selectedCategory;
  List<CategoryItem> _categories = [];
  bool _categoriesLoading = true;

  bool get _isEditing => widget.article != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.article!.title;
      _descriptionController.text = widget.article!.description;
      _contentController.text = widget.article!.content;
      _selectedCategory = widget.article!.category;
      _isPublished = widget.article!.isPublished;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await sl<FirestoreCategoryDataSource>().getCategories();
      if (mounted) setState(() { _categories = cats; _categoriesLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _categoriesLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _thumbnail = File(picked.path));
    }
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_thumbnail == null && !_isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.thumbnailRequired)),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    final authorId = authState is AuthAuthenticated ? authState.user.id : '';
    final authorName = authState is AuthAuthenticated ? authState.user.displayName : '';
    final now = DateTime.now();

    if (_isEditing) {
      final updated = ArticleEntity(
        id: widget.article!.id,
        authorId: widget.article!.authorId,
        author: widget.article!.author,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
        thumbnailPath: widget.article!.thumbnailPath,
        thumbnailURL: widget.article!.thumbnailURL,
        category: _selectedCategory,
        publishedAt: widget.article!.publishedAt,
        updatedAt: now,
        isPublished: _isPublished,
      );
      context.read<RemoteArticleBloc>().add(
            UpdateArticleEvent(article: updated, newThumbnail: _thumbnail),
          );
    } else {
      final id = const Uuid().v4();
      final article = ArticleEntity(
        id: id,
        authorId: authorId,
        author: authorName,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
        thumbnailPath: 'media/articles/$id/thumbnail.jpg',
        thumbnailURL: '',
        category: _selectedCategory,
        publishedAt: now,
        updatedAt: now,
        isPublished: _isPublished,
      );
      context.read<RemoteArticleBloc>().add(
            UploadArticleEvent(article: article, thumbnail: _thumbnail!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final authorName = authState is AuthAuthenticated ? authState.user.displayName : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editArticle : l10n.writeArticleTitle),
      ),
      body: BlocListener<RemoteArticleBloc, RemoteArticleState>(
        listener: (context, state) {
          if (state is RemoteArticleActionSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isEditing ? l10n.articleUpdated : l10n.articlePublished),
              ),
            );
          } else if (state is RemoteArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
          builder: (context, state) {
            final isLoading = state is RemoteArticleLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Builder(builder: (context) {
                      final cs = Theme.of(context).colorScheme;
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
                            image: _thumbnail != null
                                ? DecorationImage(
                                    image: FileImage(_thumbnail!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _thumbnail == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: cs.onSurface.withValues(alpha: 0.4)),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.selectThumbnail,
                                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Builder(builder: (context) {
                      final cs = Theme.of(context).colorScheme;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 18, color: cs.onSurface.withValues(alpha: 0.5)),
                            const SizedBox(width: 8),
                            Text(authorName,
                                style: TextStyle(fontSize: 15, color: cs.onSurface)),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _titleController,
                      label: l10n.titleLabel,
                      validator: (v) => v!.trim().isEmpty ? l10n.titleRequired : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _descriptionController,
                      label: l10n.descriptionLabel,
                      maxLines: 2,
                      validator: (v) => v!.trim().isEmpty ? l10n.descriptionRequired : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _contentController,
                      label: l10n.contentLabel,
                      maxLines: 8,
                      validator: (v) => v!.trim().isEmpty ? l10n.contentRequired : null,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(context, l10n),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _isPublished,
                      onChanged: (v) => setState(() => _isPublished = v),
                      title: Text(l10n.publishImmediately),
                      subtitle: Text(l10n.saveDraft),
                      activeThumbColor: AppTheme.accent,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isEditing ? l10n.updateArticle : l10n.publishArticle),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, AppLocalizations l10n) {
    final cs = Theme.of(context).colorScheme;

    if (_categoriesLoading) {
      return InputDecorator(
        decoration: InputDecoration(labelText: l10n.categoryLabel),
        child: const SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: InputDecoration(labelText: l10n.categoryLabel),
      hint: Text(
        l10n.categoryLabel,
        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(
            '— ${l10n.categoryLabel} —',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
          ),
        ),
        ..._categories.map(
          (cat) => DropdownMenuItem<String>(
            value: cat.name,
            child: Text(cat.name),
          ),
        ),
      ],
      onChanged: (val) => setState(() => _selectedCategory = val),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}
