import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ultra-premium UI foundation for e-Cut.
///
/// This file is intentionally UI-only. It does not know anything about
/// Firebase, Firestore, auth, bookings or backend models.
class ECutColors {
  ECutColors._();

  static const Color ink = Color(0xFF17121D);
  static const Color inkSoft = Color(0xFF5F5968);
  static const Color muted = Color(0xFF8C8598);

  static const Color ivory = Color(0xFFFFFBF7);
  static const Color porcelain = Color(0xFFF8F3EE);
  static const Color champagne = Color(0xFFF3E4D1);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color plum = Color(0xFF3B164F);
  static const Color plumDeep = Color(0xFF24102F);
  static const Color violet = Color(0xFF7A4BEA);
  static const Color orchid = Color(0xFFBFA3FF);
  static const Color roseGold = Color(0xFFD8A56D);
  static const Color roseGoldSoft = Color(0xFFFFE6C8);

  static const Color success = Color(0xFF1F9D69);
  static const Color warning = Color(0xFFE5A33A);
  static const Color danger = Color(0xFFE25555);

  static const Color border = Color(0xFFE9E0D8);
  static const Color field = Color(0xFFFCF8F4);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [plumDeep, plum, violet],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF6D8A8), roseGold, Color(0xFFB97943)],
  );
}

class ECutRadius {
  ECutRadius._();

  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
}

class ECutSpacing {
  ECutSpacing._();

  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 44;
}

class ECutShadows {
  ECutShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> lifted = [
    BoxShadow(
      color: Color(0x1A3B164F),
      blurRadius: 32,
      offset: Offset(0, 18),
    ),
  ];
}

class ECutTheme {
  ECutTheme._();

  static ThemeData light() {
    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 38,
        height: 1.06,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: ECutColors.ink,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: ECutColors.ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        height: 1.18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.35,
        color: ECutColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        color: ECutColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: ECutColors.ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w500,
        color: ECutColors.inkSoft,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: ECutColors.inkSoft,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        color: ECutColors.ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.35,
        color: ECutColors.muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ECutColors.plum,
        brightness: Brightness.light,
        primary: ECutColors.plum,
        secondary: ECutColors.roseGold,
        surface: ECutColors.surface,
        error: ECutColors.danger,
      ),
      scaffoldBackgroundColor: ECutColors.ivory,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ECutColors.ink,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.25,
          color: ECutColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: ECutColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ECutRadius.lg),
          side: const BorderSide(color: ECutColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ECutColors.field,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        labelStyle: const TextStyle(
          color: ECutColors.inkSoft,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: ECutColors.muted,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: ECutColors.muted,
        suffixIconColor: ECutColors.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ECutRadius.md),
          borderSide: const BorderSide(color: ECutColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ECutRadius.md),
          borderSide: const BorderSide(color: ECutColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ECutRadius.md),
          borderSide: const BorderSide(color: ECutColors.plum, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ECutRadius.md),
          borderSide: const BorderSide(color: ECutColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ECutRadius.md),
          borderSide: const BorderSide(color: ECutColors.danger, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ECutColors.plum,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ECutRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ECutColors.plum,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: ECutColors.plum,
        unselectedItemColor: ECutColors.muted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ECutColors.plumDeep,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ECutRadius.md)),
      ),
      dividerTheme: const DividerThemeData(
        color: ECutColors.border,
        thickness: 1,
      ),
    );
  }
}

class PremiumSurface extends StatelessWidget {
  const PremiumSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ECutSpacing.lg),
    this.borderRadius = ECutRadius.lg,
    this.backgroundColor = ECutColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: ECutColors.border),
        boxShadow: ECutShadows.soft,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class PremiumPrimaryButton extends StatelessWidget {
  const PremiumPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final canTap = onPressed != null && !loading;
    final contentColor = disabled ? ECutColors.inkSoft : Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: disabled ? null : ECutColors.brandGradient,
        color: disabled ? ECutColors.plumDeep.withValues(alpha: 0.12) : null,
        borderRadius: BorderRadius.circular(ECutRadius.md),
        border: disabled ? Border.all(color: ECutColors.border) : null,
        boxShadow: disabled ? null : ECutShadows.lifted,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ECutRadius.md),
        child: InkWell(
          onTap: canTap ? onPressed : null,
          borderRadius: BorderRadius.circular(ECutRadius.md),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 19, color: contentColor),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            color: contentColor,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.15,
                          ),
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

class PremiumTextField extends StatelessWidget {
  const PremiumTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: ECutColors.ink,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class PremiumBottomNav extends StatelessWidget {
  const PremiumBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _PremiumNavItem(Icons.home_rounded, 'Αρχική'),
    _PremiumNavItem(Icons.search_rounded, 'Αναζήτηση'),
    _PremiumNavItem(Icons.calendar_month_rounded, 'Ραντεβού'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom > 0 ? 10 : 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ECutColors.plumDeep.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: ECutShadows.lifted,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final selected = selectedIndex == index;
                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                      child: InkWell(
                        onTap: () => onTap(index),
                        borderRadius: BorderRadius.circular(22),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: selected ? ECutColors.goldGradient : null,
                            color: selected ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                color: selected ? ECutColors.plumDeep : Colors.white.withValues(alpha: 0.70),
                                size: 22,
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 210),
                                child: selected
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          item.label,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: ECutColors.plumDeep,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumNavItem {
  const _PremiumNavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

class PremiumSplashScreen extends StatelessWidget {
  const PremiumSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PremiumAuthBackground(
        child: Center(
          child: SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(ECutColors.plum),
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumAuthBackground extends StatelessWidget {
  const PremiumAuthBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ECutColors.ivory,
                  ECutColors.porcelain,
                  ECutColors.champagne.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -110,
          child: _BlurCircle(
            size: 260,
            color: ECutColors.orchid.withValues(alpha: 0.33),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -120,
          child: _BlurCircle(
            size: 290,
            color: ECutColors.roseGold.withValues(alpha: 0.26),
          ),
        ),
        child,
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
      child: SizedBox(width: size, height: size),
    );
  }
}

class PremiumHeroPanel extends StatelessWidget {
  const PremiumHeroPanel({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.auto_awesome_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: ECutColors.brandGradient,
        borderRadius: BorderRadius.circular(ECutRadius.lg),
        boxShadow: ECutShadows.lifted,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: SizedBox(
                width: 54,
                height: 54,
                child: Icon(icon, color: ECutColors.roseGold, size: 27),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
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

class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PremiumSurface(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: ECutColors.porcelain,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: Icon(icon, color: ECutColors.plum, size: 34),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumRatingBadge extends StatelessWidget {
  const PremiumRatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ECutColors.plumDeep.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 15, color: ECutColors.roseGold),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumStatusPill extends StatelessWidget {
  const PremiumStatusPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.2),
        ),
      ),
    );
  }
}

class PremiumStoreCard extends StatelessWidget {
  const PremiumStoreCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.subtitle,
    required this.onTap,
    this.compact = false,
  });

  final String name;
  final String imageUrl;
  final double rating;
  final String subtitle;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ECutRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ECutRadius.lg),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ECutColors.surface,
              borderRadius: BorderRadius.circular(ECutRadius.lg),
              border: Border.all(color: ECutColors.border),
              boxShadow: ECutShadows.soft,
            ),
            child: compact ? _compact(context) : _large(context),
          ),
        ),
      ),
    );
  }

  Widget _compact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _image(width: 86, height: 86, radius: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                Row(
                  children: [
                    PremiumRatingBadge(rating: rating),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ECutColors.plum),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _large(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            _image(width: double.infinity, height: 172, radius: ECutRadius.lg),
            Positioned(top: 12, right: 12, child: PremiumRatingBadge(rating: rating)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 5),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: const BoxDecoration(color: ECutColors.porcelain, shape: BoxShape.circle),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.arrow_forward_rounded, color: ECutColors.plum, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _image({required double width, required double height, required double radius}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: ECutColors.porcelain,
          child: const Icon(Icons.storefront_rounded, color: ECutColors.plum, size: 42),
        ),
      ),
    );
  }
}

/// Phase 2 motion + luxury discovery components.
/// These widgets stay UI-only and can be reused across screens without touching
/// Firebase, Firestore, Auth or booking business logic.
class ECutMotion {
  ECutMotion._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 520);
  static const Curve curve = Curves.easeOutCubic;
}

class PremiumAppBackground extends StatelessWidget {
  const PremiumAppBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ECutColors.ivory,
                  ECutColors.porcelain,
                  ECutColors.champagne.withValues(alpha: 0.64),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -140,
          right: -90,
          child: _BlurCircle(size: 330, color: ECutColors.orchid.withValues(alpha: 0.28)),
        ),
        Positioned(
          top: 210,
          left: -160,
          child: _BlurCircle(size: 300, color: ECutColors.roseGold.withValues(alpha: 0.20)),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: _BlurCircle(size: 330, color: ECutColors.violet.withValues(alpha: 0.14)),
        ),
        child,
      ],
    );
  }
}

class PremiumGlassPanel extends StatelessWidget {
  const PremiumGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ECutSpacing.lg),
    this.borderRadius = ECutRadius.xl,
    this.tint = Colors.white,
    this.opacity = 0.72,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color tint;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: ECutShadows.soft,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class PremiumSectionHeader extends StatelessWidget {
  const PremiumSectionHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(
                  eyebrow!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: ECutColors.roseGold,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                ),
                const SizedBox(height: 5),
              ],
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class PremiumSearchTrigger extends StatelessWidget {
  const PremiumSearchTrigger({
    super.key,
    required this.onTap,
    this.placeholder = 'Αναζήτησε υπηρεσία ή κατάστημα',
  });

  final VoidCallback onTap;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: PremiumGlassPanel(
          borderRadius: 22,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: ECutColors.plum, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ECutColors.inkSoft,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ECutColors.plum,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    'Βρες',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
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

class PremiumStatPill extends StatelessWidget {
  const PremiumStatPill({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.dark = false,
  });

  final String value;
  final String label;
  final IconData? icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : ECutColors.ink;
    final subColor = dark ? Colors.white.withValues(alpha: 0.70) : ECutColors.inkSoft;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? Colors.white.withValues(alpha: 0.10) : ECutColors.surface.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dark ? Colors.white.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.86)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: dark ? ECutColors.roseGold : ECutColors.plum, size: 18),
              const SizedBox(width: 8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w900)),
                Text(label, style: TextStyle(color: subColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumServiceTile extends StatelessWidget {
  const PremiumServiceTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent = ECutColors.plum,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: ECutMotion.normal,
          curve: ECutMotion.curve,
          width: 112,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
            boxShadow: ECutShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent.withValues(alpha: 0.18), ECutColors.roseGold.withValues(alpha: 0.12)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(icon, color: accent, size: 24),
                ),
              ),
              const Spacer(),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ECutColors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumFeaturedStoreCard extends StatelessWidget {
  const PremiumFeaturedStoreCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.subtitle,
    required this.onTap,
  });

  final String name;
  final String imageUrl;
  final double rating;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ECutColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
              boxShadow: ECutShadows.lifted,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      child: Image.network(
                        imageUrl,
                        height: 155,
                        width: 270,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 155,
                          width: 270,
                          decoration: const BoxDecoration(
                            gradient: ECutColors.brandGradient,
                          ),
                          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 42),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, ECutColors.plumDeep.withValues(alpha: 0.62)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(top: 12, right: 12, child: PremiumRatingBadge(rating: rating)),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Text(
                            'Επιλεγμένος συνεργάτης',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      DecoratedBox(
                        decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                        child: const SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(Icons.arrow_forward_rounded, color: ECutColors.plumDeep, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumDateChip extends StatelessWidget {
  const PremiumDateChip({
    super.key,
    required this.weekday,
    required this.day,
    required this.month,
    required this.selected,
    required this.onTap,
  });

  final String weekday;
  final String day;
  final String month;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.04 : 1,
      duration: ECutMotion.fast,
      curve: ECutMotion.curve,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: ECutMotion.normal,
            curve: ECutMotion.curve,
            width: 76,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              gradient: selected ? ECutColors.brandGradient : null,
              color: selected ? null : ECutColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: selected ? Colors.transparent : ECutColors.border),
              boxShadow: selected ? ECutShadows.lifted : ECutShadows.soft,
            ),
            child: Column(
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    color: selected ? Colors.white.withValues(alpha: 0.72) : ECutColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  day,
                  style: TextStyle(
                    color: selected ? Colors.white : ECutColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  month,
                  style: TextStyle(
                    color: selected ? ECutColors.roseGoldSoft : ECutColors.inkSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumTimeSlotChip extends StatelessWidget {
  const PremiumTimeSlotChip({
    super.key,
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = disabled
        ? ECutColors.muted.withValues(alpha: 0.55)
        : selected
            ? Colors.white
            : ECutColors.ink;

    return AnimatedScale(
      scale: selected ? 1.06 : 1,
      duration: ECutMotion.fast,
      curve: ECutMotion.curve,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: ECutMotion.normal,
            curve: ECutMotion.curve,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              gradient: selected ? ECutColors.brandGradient : null,
              color: disabled
                  ? ECutColors.porcelain.withValues(alpha: 0.46)
                  : (selected ? null : ECutColors.surface),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : disabled
                        ? ECutColors.border.withValues(alpha: 0.55)
                        : ECutColors.border,
              ),
              boxShadow: selected ? ECutShadows.soft : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w900,
                    decoration: disabled ? TextDecoration.lineThrough : null,
                    decorationColor: ECutColors.muted.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumStepLabel extends StatelessWidget {
  const PremiumStepLabel({
    super.key,
    required this.step,
    required this.title,
    this.subtitle,
  });

  final String step;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Center(
              child: Text(step, style: const TextStyle(color: ECutColors.plumDeep, fontWeight: FontWeight.w900)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

