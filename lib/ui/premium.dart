import 'package:flutter/material.dart';

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
    final enabled = onPressed != null && !loading;

    return Opacity(
      opacity: enabled ? 1 : 0.62,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: ECutColors.brandGradient,
          borderRadius: BorderRadius.circular(ECutRadius.md),
          boxShadow: ECutShadows.lifted,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ECutRadius.md),
          child: InkWell(
            onTap: enabled ? onPressed : null,
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
                            Icon(icon, size: 19, color: Colors.white),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ECutColors.surface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: ECutColors.border),
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
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selected ? ECutColors.porcelain : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: selected ? ECutColors.plum : ECutColors.muted,
                            size: 22,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: selected
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: ECutColors.plum,
                                        fontWeight: FontWeight.w800,
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
                  ECutColors.champagne.withOpacity(0.78),
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
            color: ECutColors.orchid.withOpacity(0.33),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -120,
          child: _BlurCircle(
            size: 290,
            color: ECutColors.roseGold.withOpacity(0.26),
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
          colors: [color, color.withOpacity(0)],
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
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.72)),
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
        color: ECutColors.plumDeep.withOpacity(0.88),
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
        color: color.withOpacity(0.12),
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
