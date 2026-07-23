import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_profile.dart';
import '../../core/router/app_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _expandedHeight = 318.0;

  static const _menu = <_MenuItem>[
    _MenuItem(Icons.monitor_heart_outlined, 'My Health Profile', AppRoutes.healthProfile),
    _MenuItem(Icons.history_rounded, 'My Scan History', AppRoutes.history),
    _MenuItem(Icons.menu_book_outlined, 'Health Articles', AppRoutes.articles),
    _MenuItem(Icons.help_outline_rounded, 'FAQ', AppRoutes.faq),
  ];

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    try {
      await AuthService.instance.loadSessionProfile();
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profile = AuthService.instance.profile;
    final displayName = AuthService.instance.displayName;
    final email = profile?.email ??
        AuthService.instance.firebaseUser?.email ??
        '';
    final needsSetup = AuthService.instance.needsHealthProfileSetup;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshProfile,
        edgeOffset: MediaQuery.paddingOf(context).top + kToolbarHeight,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: _expandedHeight,
              pinned: true,
              stretch: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.primaryDark,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () => context.push(AppRoutes.healthProfile),
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  tooltip: 'Edit profile',
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final topPadding = MediaQuery.paddingOf(context).top;
                  final collapsedHeight = topPadding + kToolbarHeight;
                  final expandRatio = ((constraints.maxHeight - collapsedHeight) /
                          (_expandedHeight - collapsedHeight))
                      .clamp(0.0, 1.0);

                  return FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
                    title: expandRatio < 0.55
                        ? Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          )
                        : null,
                    background: _ProfileHeader(
                      profile: profile,
                      displayName: displayName,
                      email: email,
                      expandRatio: expandRatio,
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (needsSetup) ...[
                          _SetupBanner(
                            onTap: () => context.push(AppRoutes.profileSetup),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ..._menu.map(
                          (item) => _MenuTile(
                            icon: item.icon,
                            label: item.label,
                            onTap: () {
                              if (item.route == AppRoutes.faq ||
                                  item.route == AppRoutes.healthProfile) {
                                context.push(item.route);
                              } else {
                                context.go(item.route);
                              }
                            },
                          ),
                        ),
                        if (AuthService.instance.canResetPassword)
                          _MenuTile(
                            icon: Icons.lock_reset_rounded,
                            label: 'Reset Password',
                            onTap: () {
                              final path = email.isNotEmpty
                                  ? '${AppRoutes.resetPassword}?email=${Uri.encodeComponent(email)}'
                                  : AppRoutes.resetPassword;
                              context.push(path);
                            },
                          ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 24),
                        ),
                        _MenuTile(
                          icon: Icons.logout_rounded,
                          label: 'Log Out',
                          color: AppColors.danger,
                          onTap: () => _confirmLogout(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Log Out',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await AuthService.instance.signOut();
                        if (context.mounted) context.go(AppRoutes.login);
                      },
                      child: const Text('Yes, Log Out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.displayName,
    required this.email,
    required this.expandRatio,
  });

  final UserProfile? profile;
  final String displayName;
  final String email;
  final double expandRatio;

  @override
  Widget build(BuildContext context) {
    final fade = expandRatio.clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.profileGradient),
      child: SafeArea(
        bottom: false,
        child: Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, (1 - fade) * 24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(Icons.person, size: 46, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          icon: Icons.cake_outlined,
                          value: profile?.ageDisplay ?? '—',
                          label: 'Age',
                        ),
                      ),
                      const _StatDivider(),
                      Expanded(
                        child: _Stat(
                          icon: Icons.height_rounded,
                          value: profile?.heightDisplay ?? '—',
                          label: 'Height',
                        ),
                      ),
                      const _StatDivider(),
                      Expanded(
                        child: _Stat(
                          icon: Icons.fitness_center_outlined,
                          value: profile?.weightDisplay ?? '—',
                          label: 'Weight',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupBanner extends StatelessWidget {
  const _SetupBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warning.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Complete your health profile — required for AI analyses.',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.route);
  final IconData icon;
  final String label;
  final String route;
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}
