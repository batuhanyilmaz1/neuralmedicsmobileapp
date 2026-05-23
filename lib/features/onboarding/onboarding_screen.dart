import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const _pages = <_OnboardData>[
    _OnboardData(
      title: 'AI destekli beyin MR analizi ile erken farkındalık',
      icon: Icons.psychology_rounded,
      color: AppColors.primary,
    ),
    _OnboardData(
      title: 'Sağlık profilinizi oluşturun, kişiselleştirilmiş karar desteği alın',
      icon: Icons.monitor_heart_outlined,
      color: AppColors.accent,
    ),
    _OnboardData(
      title: 'Tarama geçmişiniz cihazınızda güvenle saklanır',
      icon: Icons.security_rounded,
      color: AppColors.primaryDark,
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _skip() => context.go(AppRoutes.login);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Atla',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 240,
                              height: 320,
                              decoration: BoxDecoration(
                                color: p.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(140),
                              ),
                              child: Icon(p.icon, size: 130, color: p.color),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            height: 1.25,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    _Indicator(
                                      count: _pages.length,
                                      current: _index,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              _CircleArrowButton(onTap: _next),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  const _OnboardData({
    required this.title,
    required this.icon,
    required this.color,
  });
  final String title;
  final IconData icon;
  final Color color;
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.only(right: 6),
          height: 6,
          width: active ? 22 : 10,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _CircleArrowButton extends StatelessWidget {
  const _CircleArrowButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Icon(Icons.arrow_forward_rounded,
              color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
