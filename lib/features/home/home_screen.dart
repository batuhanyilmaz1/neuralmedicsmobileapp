import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/health_articles.dart';
import '../../core/models/health_article.dart';
import '../../core/router/app_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/greeting_name.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = greetingFirstName(AuthService.instance.displayName);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your AI-powered brain MRI decision support system',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              _CategoryRow(
                items: [
                  _CategoryItem(
                    icon: Icons.psychology_outlined,
                    label: 'AI Scan',
                    onTap: () => context.push(AppRoutes.aiTumor),
                    highlight: true,
                  ),
                  _CategoryItem(
                    icon: Icons.history_rounded,
                    label: 'History',
                    onTap: () => context.go(AppRoutes.history),
                  ),
                  _CategoryItem(
                    icon: Icons.menu_book_outlined,
                    label: 'Articles',
                    onTap: () => context.go(AppRoutes.articles),
                  ),
                  _CategoryItem(
                    icon: Icons.monitor_heart_outlined,
                    label: 'My Profile',
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _PromoCard(
                onLearnMore: () => context.push(
                  AppRoutes.articleDetailPath('beyin-tumoru-belirtileri'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Health Articles',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.articles),
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...HealthArticles.featured.map(
                (article) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ArticleCard(
                    article: article,
                    onTap: () => context.push(
                      AppRoutes.articleDetailPath(article.id),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.items});
  final List<_CategoryItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((e) => Expanded(child: Center(child: e)))
          .toList(growable: false),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: highlight ? AppColors.primary : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: highlight ? Colors.white : AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: highlight ? AppColors.primary : AppColors.textSecondary,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.onLearnMore});
  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Early awareness,\n more informed decisions',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onLearnMore,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Learn more',
                      style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.psychology_alt_outlined,
                size: 40, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final HealthArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(article.icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${article.category} • ${article.readMinutes} min read',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
