import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'ui/premium.dart';

// 1. Φτιάχνουμε το αντικείμενο των ειδοποιήσεων
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// ---------------- DESIGN SYSTEM TOKENS ----------------
/// UI-only refactor (colors/typography/radius) so we don't touch backend logic.
class AppColors {
  // Brand (Ultra‑Premium Purple)
  static const Color primary = Color(0xFF4A0F66);
  static const Color primaryLight = Color(0xFF6B34D6);
  static const Color secondary = Color(0xFFD4A373); // rose-gold
  static const Color secondarySoft = Color(0xFFBFA3FF); // soft lilac

  // iOS Vibe
  static const Color backgroundGrouped = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B6B6F);
  static const Color outline = Color(0xFFE5E5EA);

  // Primary tints (replacement for purple.shadeXX / deepPurple.shadeXX)
  static const Color primarySoft = Color(0xFFF4ECFF);
  static const Color primarySoft2 = Color(0xFFE7D7FF);

  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4A0F66,
    <int, Color>{
      50: Color(0xFFF4ECFF),
      100: Color(0xFFE7D7FF),
      200: Color(0xFFD2B6FF),
      300: Color(0xFFB98FFF),
      400: Color(0xFFA06FEA),
      500: Color(0xFF4A0F66),
      600: Color(0xFF3D0C58),
      700: Color(0xFF2C0A43),
      800: Color(0xFF200731),
      900: Color(0xFF16041F),
    },
  );
}


const List<String> _greekMonthsGenitive = [
  'Ιανουαρίου',
  'Φεβρουαρίου',
  'Μαρτίου',
  'Απριλίου',
  'Μαΐου',
  'Ιουνίου',
  'Ιουλίου',
  'Αυγούστου',
  'Σεπτεμβρίου',
  'Οκτωβρίου',
  'Νοεμβρίου',
  'Δεκεμβρίου',
];

const List<String> _greekWeekdays = [
  'Δευτέρα',
  'Τρίτη',
  'Τετάρτη',
  'Πέμπτη',
  'Παρασκευή',
  'Σάββατο',
  'Κυριακή',
];

String _formatGreekDate(DateTime date, {bool includeYear = true, bool includeWeekday = false}) {
  final month = _greekMonthsGenitive[date.month - 1];
  final datePart = includeYear ? '${date.day} $month ${date.year}' : '${date.day} $month';
  if (!includeWeekday) return datePart;
  return '${_greekWeekdays[date.weekday - 1]} $datePart';
}

String _formatGreekDateFromIso(String value, {bool includeYear = true, bool includeWeekday = true}) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  return _formatGreekDate(parsed, includeYear: includeYear, includeWeekday: includeWeekday);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // 2. Ρυθμίσεις για Android & iOS
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(); // Για iOS/macOS
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  
  // 3. Αρχικοποίηση
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const ECutApp());
}

class ECutApp extends StatelessWidget {
  const ECutApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'e-Cut',
      theme: ECutTheme.light(),
      supportedLocales: const [
        Locale('el', 'GR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}

/// ---------------- AUTH GATE (Με Ειδοποιήσεις) ----------------
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  
  // Συνάρτηση που "ακούει" τη βάση για αλλαγές
  void _listenForNotifications(String uid) {
    FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'confirmed')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          
          debugPrint("🔥 ΕΝΤΟΠΙΣΤΗΚΕ ΑΛΛΑΓΗ ΣΤΗ ΒΑΣΗ!"); 
          
          final data = change.doc.data();
          if (data != null) {
            _showNotification(
              '✅ Το ραντεβού επιβεβαιώθηκε!',
              'Ραντεβού στο ${data['storeName']} για ${data['serviceName']}.',
            );
          }
        }
      }
    });
  }

  // Συνάρτηση που εμφανίζει το μήνυμα στο κινητό
  Future<void> _showNotification(String title, String body) async {
    debugPrint("🔔 ΠΡΟΣΠΑΘΕΙΑ ΕΙΔΟΠΟΙΗΣΗΣ: $title"); 

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'booking_channel', 'Booking Updates',
      importance: Importance.max, priority: Priority.high,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true, 
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails, 
    );
    
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, 
      title, 
      body, 
      details,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // 1. Αν φορτώνει ακόμα
        if (snap.connectionState == ConnectionState.waiting) {
          return const PremiumSplashScreen();
        }

        // 2. Αν ο χρήστης είναι συνδεδεμένος
        if (snap.hasData) {
          // Ζητάμε άδεια για ειδοποιήσεις
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true);

          // Ξεκινάμε να ακούμε για αλλαγές
          _listenForNotifications(snap.data!.uid); 

          return const MainLayout(); 
        }

        // 3. Αν δεν είναι συνδεδεμένος -> Πάμε στο Login
        return const SignInPage();
      },
    );
  }
} 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loginMode = true;
  bool _loading = false;
  bool _showPassword = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_loginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Σφάλμα σύνδεσης')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRegister = !_loginMode;

    return Scaffold(
      body: PremiumAuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.88)),
                          boxShadow: ECutShadows.soft,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 86,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      isRegister ? 'Ξεκίνα την premium εμπειρία σου' : 'Κλείσε την επόμενη περιποίησή σου',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRegister
                          ? 'Δημιούργησε λογαριασμό και ανακάλυψε επιλεγμένες beauty & wellness υπηρεσίες.'
                          : 'Ανακάλυψε επιλεγμένους επαγγελματίες ομορφιάς, διαθεσιμότητα και ραντεβού σε λίγα δευτερόλεπτα.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    PremiumSurface(
                      padding: const EdgeInsets.all(22),
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _AuthModePill(
                                    label: 'Σύνδεση',
                                    selected: _loginMode,
                                    onTap: () => setState(() => _loginMode = true),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _AuthModePill(
                                    label: 'Εγγραφή',
                                    selected: !_loginMode,
                                    onTap: () => setState(() => _loginMode = false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            PremiumTextField(
                              controller: _email,
                              label: 'Email',
                              hint: 'name@example.com',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                return value.contains('@') && value.contains('.')
                                    ? null
                                    : 'Δώσε έγκυρο email';
                              },
                            ),
                            const SizedBox(height: 16),
                            PremiumTextField(
                              controller: _pass,
                              label: 'Κωδικός',
                              hint: 'Τουλάχιστον 6 χαρακτήρες',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: !_showPassword,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _showPassword = !_showPassword),
                                icon: Icon(
                                  _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                ),
                              ),
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες'
                                  : null,
                            ),
                            const SizedBox(height: 22),
                            PremiumPrimaryButton(
                              label: _loginMode ? 'Σύνδεση στο e-Cut' : 'Δημιουργία λογαριασμού',
                              icon: _loginMode ? Icons.arrow_forward_rounded : Icons.auto_awesome_rounded,
                              loading: _loading,
                              onPressed: _loading ? null : _submit,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              _loginMode
                                  ? 'Με τη σύνδεση συνεχίζεις στην προσωπική σου εμπειρία ομορφιάς.'
                                  : 'Η εγγραφή ολοκληρώνεται άμεσα και μπορείς να κλείσεις ραντεβού αμέσως.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_rounded, size: 18, color: ECutColors.roseGold),
                        const SizedBox(width: 8),
                        Text(
                          'Επιλεγμένες κρατήσεις ομορφιάς & wellness',
                          style: theme.textTheme.labelMedium?.copyWith(color: ECutColors.inkSoft),
                        ),
                      ],
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

class _AuthModePill extends StatelessWidget {
  const _AuthModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 46,
          decoration: BoxDecoration(
            color: selected ? ECutColors.plum : ECutColors.porcelain,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? ECutColors.plum : ECutColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : ECutColors.inkSoft,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------- LOCATION HELPERS -------------
class LocationHelper {
  static Future<Position?> getCurrentPosition(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!context.mounted) return null;
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ενεργοποίησε το GPS για κοντινά καταστήματα')),
      );
      return null;
    }
    var permission = await Geolocator.checkPermission();
    if (!context.mounted) return null;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!context.mounted) return null;
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Δεν δόθηκε άδεια τοποθεσίας')),
      );
      return null;
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  static double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000.0;
  }
}


/// ---------------- HOME SCREEN (FINAL VERSION) ----------------
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // Ποια καρτέλα είναι ενεργή

  // Οι 3 Οθόνες της εφαρμογής που εναλλάσσονται
  final List<Widget> _pages = [
    const HomeContent(),       // 0: Αρχική
    const StoreSearchScreen(), // 1: Αναζήτηση
    const UserBookingsScreen(),// 2: Ραντεβού
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Εμφανίζουμε την οθόνη ανάλογα με το ποιο κουμπί πατήθηκε κάτω
      body: IndexedStack( // Το IndexedStack κρατάει την κατάσταση της οθόνης ζωντανή
        index: _selectedIndex,
        children: _pages,
      ),
      
      bottomNavigationBar: PremiumBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// ---------------- ΤΟ ΠΕΡΙΕΧΟΜΕΝΟ ΤΗΣ ΑΡΧΙΚΗΣ (HomeContent) ----------------
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late final AnimationController _introController;
  // --- ΚΩΔΙΚΑΣ ΕΙΔΟΠΟΙΗΣΕΩΝ (Κρατήσαμε τον δικό σου) ---
  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _checkPermission();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) _listenGlobal(user.uid);
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _listenGlobal(String uid) {
    FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null && data['status'] == 'confirmed') {
             _showNotification('✅ Το ραντεβού εγκρίθηκε!', 'Το ραντεβού στο ${data['storeName']} επιβεβαιώθηκε.');
             if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Το ραντεβού επιβεβαιώθηκε!'), backgroundColor: Colors.green));
             }
          }
        }
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'booking_channel', 'Booking Updates', importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(DateTime.now().millisecond, title, body, details);
  }
  // -----------------------------------------------------

  final List<Map<String, dynamic>> services = [
    {'name': 'Κούρεμα', 'icon': Icons.content_cut, 'color': AppColors.primaryLight},
    {'name': 'Ξύρισμα', 'icon': Icons.face, 'color': AppColors.secondarySoft},
    {'name': 'Βαφή', 'icon': Icons.color_lens, 'color': AppColors.secondary},
    {'name': 'Περιποίηση', 'icon': Icons.spa, 'color': AppColors.primary},
  ];

  Widget _buildEntrance({
    required int order,
    required Widget child,
  }) {
    final start = ((order * 0.12).clamp(0.0, 0.8)).toDouble();
    final end = ((start + 0.35).clamp(start + 0.1, 1.0)).toDouble();
    final animation = CurvedAnimation(
      parent: _introController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, builtChild) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 18),
            child: builtChild,
          ),
        );
      },
    );
  }

  double _readRating(Map<String, dynamic> data) {
    final raw = data['rating'];
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '') ?? 0.0;
  }

  List<dynamic> _readServices(Map<String, dynamic> data) {
    final raw = data['services'];
    return raw is List ? raw : <dynamic>[];
  }

  void _openSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreSearchScreen()));
  }

  void _showOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Row(
          children: [
            Icon(Icons.local_offer_rounded, color: ECutColors.roseGold),
            SizedBox(width: 10),
            Text('Ιδιωτικό προνόμιο'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Κράτησε 20% έκπτωση για το επόμενο ραντεβού ομορφιάς σου.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: ECutColors.goldGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                child: Center(
                  child: Text(
                    'ECUT2026',
                    style: TextStyle(
                      color: ECutColors.plumDeep,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Τέλεια')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ECutColors.ivory,
      body: PremiumAppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 156),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEntrance(
                  order: 0,
                  child: SizedBox(
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                                icon: const Icon(Icons.person_outline_rounded),
                                color: ECutColors.plum,
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed: () => FirebaseAuth.instance.signOut(),
                                icon: const Icon(Icons.logout_rounded),
                                color: ECutColors.muted,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildEntrance(
                  order: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: ECutColors.brandGradient,
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: ECutShadows.lifted,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                                ),
                                child: const SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Icon(Icons.auto_awesome_rounded, color: ECutColors.roseGold, size: 26),
                                ),
                              ),
                              const Spacer(),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Text(
                                    'Ραντεβού αυθημερόν',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Κλείσε υπηρεσίες ομορφιάς με premium εμπειρία.',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Ανακάλυψε επιλεγμένους επαγγελματίες, διάλεξε υπηρεσία και κλείσε ραντεβού σε λίγα λεπτά.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.74)),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              PremiumStatPill(value: '4.9', label: 'αξιολόγηση', icon: Icons.star_rounded, dark: true),
                              SizedBox(width: 10),
                              PremiumStatPill(value: '30λ', label: 'άμεσες ώρες', icon: Icons.schedule_rounded, dark: true),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PremiumPrimaryButton(
                            label: 'Αναζήτηση υπηρεσίας',
                            icon: Icons.search_rounded,
                            onPressed: _openSearch,
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _showOfferDialog,
                            icon: const Icon(Icons.card_giftcard_rounded, color: ECutColors.roseGold),
                            label: const Text('Δες τον ιδιωτικό κωδικό έκπτωσης'),
                            style: TextButton.styleFrom(foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildEntrance(
                  order: 2,
                  child: PremiumSearchTrigger(onTap: _openSearch),
                ),
                const SizedBox(height: 28),
                _buildEntrance(
                  order: 3,
                  child: const PremiumSectionHeader(
                    eyebrow: 'Ομορφιά & wellness',
                    title: 'Τι χρειάζεσαι σήμερα;',
                    subtitle: 'Γρήγορη επιλογή υπηρεσίας με επιλεγμένους συνεργάτες.',
                  ),
                ),
                const SizedBox(height: 14),
                _buildEntrance(
                  order: 4,
                  child: SizedBox(
                    height: 126,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: services.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return PremiumServiceTile(
                          label: service['name'] as String,
                          icon: service['icon'] as IconData,
                          accent: service['color'] as Color,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => StoreListScreen(serviceName: service['name'] as String)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildEntrance(
                  order: 5,
                  child: PremiumSectionHeader(
                    eyebrow: 'Επιλογές e-Cut',
                    title: 'Δημοφιλή καταστήματα',
                    subtitle: 'Οι συνεργάτες που ξεχωρίζουν αυτή την εβδομάδα.',
                    actionLabel: 'Όλα',
                    onAction: _openSearch,
                  ),
                ),
                const SizedBox(height: 14),
                _buildEntrance(
                  order: 6,
                  child: SizedBox(
                    height: 238,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('stores').limit(7).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final stores = snapshot.data?.docs ?? [];
                        if (stores.isEmpty) {
                          return const PremiumEmptyState(
                            icon: Icons.storefront_outlined,
                            title: 'Δεν βρέθηκαν καταστήματα',
                            message: 'Μόλις προστεθούν συνεργάτες θα εμφανιστούν εδώ.',
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: stores.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final data = stores[index].data() as Map<String, dynamic>;
                            final name = (data['name'] ?? 'Άγνωστο Μαγαζί').toString();
                            final image = (data['photoUrl'] ?? 'https://via.placeholder.com/700x500').toString();
                            final rating = _readRating(data);
                            final storeServices = _readServices(data);
                            final subtitle = storeServices.isEmpty ? 'Στούντιο ομορφιάς & wellness' : storeServices.take(2).join(' • ');

                            return PremiumFeaturedStoreCard(
                              name: name,
                              imageUrl: image,
                              rating: rating,
                              subtitle: subtitle,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoreServicesScreen(storeName: name, services: storeServices),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildEntrance(
                  order: 7,
                  child: PremiumGlassPanel(
                    padding: const EdgeInsets.all(18),
                    borderRadius: 26,
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                          child: const SizedBox(
                            width: 52,
                            height: 52,
                            child: Icon(Icons.verified_rounded, color: ECutColors.plumDeep),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Αξιόπιστη κράτηση', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                'Επιβεβαίωση από το κατάστημα, ιστορικό ραντεβού και ειδοποιήσεις σε μία καθαρή εμπειρία.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
/// ------------- STORE LIST SCREEN ----------------
class StoreListScreen extends StatefulWidget {
  final String serviceName;
  const StoreListScreen({super.key, required this.serviceName});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  double _readRating(Map<String, dynamic> data) {
    final raw = data['rating'];
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '') ?? 0.0;
  }

  List<dynamic> _readServices(Map<String, dynamic> data) {
    final raw = data['services'];
    return raw is List ? raw : <dynamic>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(
        title: Text(widget.serviceName),
      ),
      body: PremiumAppBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('stores')
              .where('services', arrayContains: widget.serviceName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const PremiumEmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Κάτι πήγε στραβά',
              message: 'Δεν μπορέσαμε να φορτώσουμε τα διαθέσιμα καταστήματα.',
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return PremiumEmptyState(
              icon: Icons.spa_outlined,
              title: 'Δεν βρέθηκαν καταστήματα',
              message: 'Δεν υπάρχουν ακόμα συνεργάτες για ${widget.serviceName}. Δοκίμασε άλλη υπηρεσία.',
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
            itemCount: docs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: PremiumHeroPanel(
                    title: 'Επιλεγμένα καταστήματα για ${widget.serviceName}',
                    subtitle: '${docs.length} διαθέσιμα καταστήματα για κράτηση',
                    icon: Icons.storefront_rounded,
                  ),
                );
              }

              final data = docs[index - 1].data() as Map<String, dynamic>;
              final image = (data['photoUrl'] ?? 'https://via.placeholder.com/600x400').toString();
              final name = (data['name'] ?? 'Άγνωστο Μαγαζί').toString();
              final rating = _readRating(data);
              final storeServices = _readServices(data);

              return PremiumStoreCard(
                name: name,
                imageUrl: image,
                rating: rating,
                subtitle: 'Διαθέσιμο για κράτηση • Επιβεβαίωση από το κατάστημα',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoreServicesScreen(
                        storeName: name,
                        services: storeServices,
                      ),
                    ),
                  );
                },
              );
            },
          );
          },
        ),
      ),
    );
  }
}
/// ---------------- SELECT STAFF SCREEN (PREMIUM) ----------------
class SelectStaffScreen extends StatelessWidget {
  final String storeName;
  final String serviceName;

  const SelectStaffScreen({
    super.key,
    required this.storeName,
    required this.serviceName,
  });

  bool _isEmployeeSuitable(String role, String service) {
    final r = role.toLowerCase();
    final s = service.toLowerCase();

    if (s.contains('κούρεμα') || s.contains('χτένισμα')) {
      return r.contains('barber') || r.contains('stylist') || r.contains('κομμωτ');
    }
    if (s.contains('ξύρισμα')) {
      return r.contains('barber') || r.contains('κουρέας');
    }
    if (s.contains('βαφή')) {
      return r.contains('colorist') || r.contains('stylist');
    }
    if (s.contains('περιποίηση') || s.contains('θεραπεία')) {
      return r.contains('beauty') || r.contains('expert') || r.contains('barber');
    }
    return true;
  }

  String _initial(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(
        title: const Text('Επιλογή επαγγελματία'),
      ),
      body: PremiumAppBackground(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
            child: PremiumHeroPanel(
              title: serviceName,
              subtitle: 'Διάλεξε τον επαγγελματία που ταιριάζει καλύτερα στην υπηρεσία σου.',
              icon: Icons.badge_outlined,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('staff_members')
                  .where('storeName', isEqualTo: storeName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final allDocs = snapshot.data!.docs;
                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final role = (data['role'] ?? '').toString();
                  return _isEmployeeSuitable(role, serviceName);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return PremiumEmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'Δεν βρέθηκε διαθέσιμος συνεργάτης',
                    message: 'Δεν υπάρχουν εξειδικευμένοι συνεργάτες για "$serviceName" αυτή τη στιγμή.',
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    final staffName = (data['name'] ?? 'Συνεργάτης').toString();
                    final staffRole = (data['role'] ?? 'Ειδικός ομορφιάς').toString();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(ECutRadius.lg),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(ECutRadius.lg),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(
                                  storeName: storeName,
                                  serviceName: serviceName,
                                  staffName: staffName,
                                ),
                              ),
                            );
                          },
                          child: PremiumSurface(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                DecoratedBox(
                                  decoration: const BoxDecoration(
                                    gradient: ECutColors.goldGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: Center(
                                      child: Text(
                                        _initial(staffName),
                                        style: const TextStyle(color: ECutColors.plumDeep, fontSize: 22, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(staffName, style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      Text(staffRole, style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: ECutColors.plum, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// ---------------- BOOKING SCREEN (ΜΕ ΦΟΡΜΑ ΣΤΟΙΧΕΙΩΝ) ----------------
class BookingScreen extends StatefulWidget {
  final String storeName;
  final String serviceName;
  final String staffName;

  const BookingScreen({
    super.key,
    required this.storeName,
    required this.serviceName,
    required this.staffName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _isLoading = false;
  List<String> _occupiedTimes = []; // Λίστα με τις "πιασμένες" ώρες
  // Ελεγκτές φόρμας
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    _checkAvailability(); // Έλεγχος διαθεσιμότητας με το που ανοίγει
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _prefillUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!mounted) return;
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _surnameController.text = data['surname'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    }
  }

  // --- Η ΝΕΑ ΣΥΝΑΡΤΗΣΗ ΕΛΕΓΧΟΥ ΔΙΑΘΕΣΙΜΟΤΗΤΑΣ ---
  Future<void> _checkAvailability() async {
    setState(() => _isLoading = true); // Δείχνουμε ότι φορτώνει
    try {
      final dateStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2,'0')}-${_selectedDate.day.toString().padLeft(2,'0')}";

      // Ρωτάμε τη βάση: Ποια ραντεβού υπάρχουν για αυτή τη μέρα, μαγαζί και υπάλληλο;
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('storeName', isEqualTo: widget.storeName)
          .where('staffName', isEqualTo: widget.staffName)
          .where('date', isEqualTo: dateStr)
          .get();

      List<String> busySlots = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Αν το ραντεβού δεν έχει ακυρωθεί, η ώρα θεωρείται πιασμένη
        if (data['status'] != 'canceled') {
          busySlots.add(data['time']);
        }
      }

      if (!mounted) return;
      setState(() {
        _occupiedTimes = busySlots; // Ενημερώνουμε τη λίστα
        _isLoading = false;
      });

    } catch (e) {
      debugPrint("Error checking availability: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }
  // ------------------------------------------------

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  double _timeToDouble(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) + int.parse(parts[1]) / 60.0;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayShort(DateTime date) {
    const values = ['ΔΕΥ', 'ΤΡΙ', 'ΤΕΤ', 'ΠΕΜ', 'ΠΑΡ', 'ΣΑΒ', 'ΚΥΡ'];
    return values[date.weekday - 1];
  }

  String _monthShort(DateTime date) {
    const values = ['ΙΑΝ', 'ΦΕΒ', 'ΜΑΡ', 'ΑΠΡ', 'ΜΑΪ', 'ΙΟΥΝ', 'ΙΟΥΛ', 'ΑΥΓ', 'ΣΕΠ', 'ΟΚΤ', 'ΝΟΕ', 'ΔΕΚ'];
    return values[date.month - 1];
  }

  String _displayDate(DateTime date) {
    final includeYear = date.year != DateTime.now().year;
    return _formatGreekDate(date, includeYear: includeYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(
        title: const Text('Κλείσε ραντεβού'),
      ),
      body: PremiumAppBackground(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('stores')
              .where('name', isEqualTo: widget.storeName)
              .limit(1)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isOpen = true;
            String openTime = '10:00';
            String closeTime = '20:00';

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final storeData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final hours = storeData['operatingHours'] as Map<String, dynamic>?;
              final dayName = _getDayName(_selectedDate.weekday);

              if (hours != null && hours.containsKey(dayName)) {
                isOpen = hours[dayName]['isOpen'] ?? true;
                openTime = hours[dayName]['open'] ?? '10:00';
                closeTime = hours[dayName]['close'] ?? '20:00';
              }
            }

            final timeSlots = <String>[];
            if (isOpen) {
              final start = _timeToDouble(openTime);
              final end = _timeToDouble(closeTime);
              for (double t = start; t < end; t += 0.5) {
                final h = t.floor();
                final m = ((t - h) * 60).round();
                timeSlots.add('${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}');
              }
            }

            final dates = List<DateTime>.generate(14, (index) => DateTime.now().add(Duration(days: index)));
            final availableSlots = (timeSlots.length - _occupiedTimes.length).clamp(0, timeSlots.length);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: ECutColors.brandGradient,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: ECutShadows.lifted,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                                child: const SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: Icon(Icons.spa_rounded, color: ECutColors.plumDeep, size: 27),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.storeName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.serviceName} με ${widget.staffName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              PremiumStatPill(value: _displayDate(_selectedDate), label: 'ημερομηνία', icon: Icons.calendar_today_rounded, dark: true),
                              const SizedBox(width: 10),
                              PremiumStatPill(value: _selectedTime ?? '--:--', label: 'ώρα', icon: Icons.schedule_rounded, dark: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const PremiumStepLabel(
                    step: '1',
                    title: 'Διάλεξε ημέρα',
                    subtitle: 'Οι διαθέσιμες ώρες ενημερώνονται αυτόματα.',
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        return PremiumDateChip(
                          weekday: _weekdayShort(date),
                          day: date.day.toString(),
                          month: _monthShort(date),
                          selected: _isSameDate(date, _selectedDate),
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                              _selectedTime = null;
                            });
                            _checkAvailability();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  PremiumStepLabel(
                    step: '2',
                    title: 'Διάλεξε ώρα',
                    subtitle: isOpen ? '$availableSlots διαθέσιμες ώρες • $openTime–$closeTime' : 'Το κατάστημα είναι κλειστό αυτή την ημέρα.',
                  ),
                  const SizedBox(height: 14),
                  if (!isOpen)
                    const PremiumEmptyState(
                      icon: Icons.lock_clock_rounded,
                      title: 'Κλειστά σήμερα',
                      message: 'Δοκίμασε διαφορετική ημερομηνία για να δεις διαθέσιμες ώρες.',
                    )
                  else if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    PremiumGlassPanel(
                      borderRadius: 26,
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: timeSlots.map((time) {
                          final isTaken = _occupiedTimes.contains(time);
                          final isSelected = _selectedTime == time;
                          return PremiumTimeSlotChip(
                            label: time,
                            disabled: isTaken,
                            selected: isSelected,
                            onTap: () => setState(() => _selectedTime = isSelected ? null : time),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 26),
                  const PremiumStepLabel(
                    step: '3',
                    title: 'Στοιχεία επικοινωνίας',
                    subtitle: 'Θα χρησιμοποιηθούν μόνο για την επιβεβαίωση του ραντεβού.',
                  ),
                  const SizedBox(height: 14),
                  PremiumGlassPanel(
                    borderRadius: 26,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        PremiumTextField(
                          controller: _nameController,
                          label: 'Όνομα',
                          prefixIcon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 12),
                        PremiumTextField(
                          controller: _surnameController,
                          label: 'Επίθετο',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                        PremiumTextField(
                          controller: _phoneController,
                          label: 'Τηλέφωνο',
                          prefixIcon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  PremiumGlassPanel(
                    borderRadius: 26,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(Icons.verified_outlined, color: ECutColors.plumDeep),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Αίτημα επιβεβαίωσης', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                'Το κατάστημα θα εγκρίνει το ραντεβού και θα λάβεις ειδοποίηση.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  PremiumPrimaryButton(
                    label: _selectedTime == null ? 'Επίλεξε ώρα για συνέχεια' : 'Επιβεβαίωση ραντεβού',
                    icon: Icons.check_rounded,
                    loading: _isLoading,
                    onPressed: (_selectedTime == null) ? null : _confirmBooking,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    if (_nameController.text.isEmpty || _surnameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Συμπληρώστε όλα τα στοιχεία!')));
      return;
    }

    setState(() => _isLoading = true); // Εδώ χρησιμοποιούμε το ίδιο isLoading για το κουμπί
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final dateStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2,'0')}-${_selectedDate.day.toString().padLeft(2,'0')}";

      await FirebaseFirestore.instance.collection('bookings').add({
        'storeName': widget.storeName,
        'serviceName': widget.serviceName,
        'staffName': widget.staffName,
        'date': dateStr,
        'time': _selectedTime,
        'userId': user.uid,
        'clientName': _nameController.text.trim(),
        'clientSurname': _surnameController.text.trim(),
        'clientPhone': _phoneController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: PremiumGlassPanel(
              borderRadius: 32,
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ECutColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  DecoratedBox(
                    decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                    child: const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(Icons.check_rounded, color: ECutColors.plumDeep, size: 42),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Το ραντεβού καταχωρήθηκε', textAlign: TextAlign.center, style: Theme.of(ctx).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Το αίτημα στάλθηκε στο κατάστημα. Θα λάβεις ειδοποίηση μόλις επιβεβαιωθεί.',
                    style: Theme.of(ctx).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PremiumPrimaryButton(
                    label: 'Επιστροφή στην αρχική',
                    icon: Icons.home_rounded,
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Σφάλμα: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
/// ------------- MY BOOKINGS SCREEN (NEW) ----------------
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed': return Colors.green;
      case 'canceled': return Colors.red;
      default: return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed': return 'Επιβεβαιώθηκε';
      case 'canceled': return 'Ακυρώθηκε';
      default: return 'Εκκρεμεί';
    }
  }

  Future<void> _cancelBooking(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ακύρωση Ραντεβού'),
        content: const Text('Είστε σίγουροι ότι θέλετε να ακυρώσετε;'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Όχι')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ναι, Ακύρωση')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('bookings').doc(docId).update({
        'status': 'canceled',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Το ραντεβού ακυρώθηκε.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Κάνε σύνδεση πρώτα.')));
    }

    final query = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrouped,
      appBar: AppBar(
        title: const Text('Τα Ραντεβού μου'),
        backgroundColor: AppColors.primaryLight,
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Σφάλμα: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text('Δεν έχεις κλείσει ραντεβού ακόμα.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending';
              final color = _getStatusColor(status);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white, 
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 140, 
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['storeName'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getStatusText(status),
                                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.content_cut, size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(data['serviceName'] ?? ''),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_filled, size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text('${_formatGreekDateFromIso((data['date'] ?? '').toString(), includeWeekday: false)} στις ${data['time']}'),
                                ],
                              ),
                              
                              if (status == 'pending') ...[
                                const Divider(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _cancelBooking(context, doc.id),
                                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                    label: const Text('Ακύρωση', style: TextStyle(color: Colors.red)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
/// ---------------- PROFILE SCREEN ----------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Φόρτωση στοιχείων από το Firebase
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!mounted) return;
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _nameController.text = data['name'] ?? '';
          _surnameController.text = data['surname'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Σφάλμα φόρτωσης: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Αποθήκευση στοιχείων
  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': user.email, // Καλό είναι να υπάρχει και το email
      }, SetOptions(merge: true)); // merge: true για να μην σβήσει άλλα πεδία (π.χ. role)

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Τα στοιχεία αποθηκεύτηκαν!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Σφάλμα: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(title: const Text('Το προφίλ μου')),
      body: PremiumAppBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: ECutColors.brandGradient,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: ECutShadows.lifted,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: const BoxDecoration(gradient: ECutColors.goldGradient, shape: BoxShape.circle),
                              child: SizedBox(
                                width: 68,
                                height: 68,
                                child: Center(
                                  child: Text(
                                    (user?.email ?? 'e').substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: ECutColors.plumDeep, fontSize: 28, fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Το προφίλ σου', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.email ?? 'Συνδεδεμένος χρήστης',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const PremiumStepLabel(
                      step: '1',
                      title: 'Προσωπικά στοιχεία',
                      subtitle: 'Χρησιμοποιούνται για πιο γρήγορη ολοκλήρωση της κράτησης.',
                    ),
                    const SizedBox(height: 14),
                    PremiumGlassPanel(
                      borderRadius: 28,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          PremiumTextField(controller: _nameController, label: 'Όνομα', prefixIcon: Icons.person_rounded),
                          const SizedBox(height: 12),
                          PremiumTextField(controller: _surnameController, label: 'Επίθετο', prefixIcon: Icons.person_outline_rounded),
                          const SizedBox(height: 12),
                          PremiumTextField(
                            controller: _phoneController,
                            label: 'Τηλέφωνο',
                            prefixIcon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PremiumPrimaryButton(
                      label: 'Αποθήκευση στοιχείων',
                      icon: Icons.save_rounded,
                      loading: _isLoading,
                      onPressed: _saveProfile,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout_rounded, color: ECutColors.danger),
                      label: const Text('Αποσύνδεση', style: TextStyle(color: ECutColors.danger, fontWeight: FontWeight.w900)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: const BorderSide(color: ECutColors.danger),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
/// ---------------- ΟΘΟΝΗ ΙΣΤΟΡΙΚΟΥ ΡΑΝΤΕΒΟΥ (UserBookingsScreen) ----------------
class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  Color _statusColor(String status) {
    if (status == 'confirmed') return ECutColors.success;
    if (status == 'canceled') return ECutColors.danger;
    return ECutColors.warning;
  }

  String _statusText(String status) {
    if (status == 'confirmed') return 'ΕΓΚΡΙΘΗΚΕ';
    if (status == 'canceled') return 'ΑΚΥΡΩΘΗΚΕ';
    return 'ΕΚΚΡΕΜΕΙ';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Scaffold(body: Center(child: Text('Πρέπει να συνδεθείτε.')));

    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(title: const Text('Τα ραντεβού μου')),
      body: PremiumAppBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const PremiumEmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Δεν φορτώθηκαν τα ραντεβού',
              message: 'Έλεγξε τη σύνδεσή σου και δοκίμασε ξανά.',
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const PremiumEmptyState(
              icon: Icons.calendar_today_outlined,
              title: 'Δεν έχεις ραντεβού ακόμα',
              message: 'Κλείσε την πρώτη σου υπηρεσία και θα εμφανιστεί εδώ.',
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final status = (data['status'] ?? 'pending').toString();
              final color = _statusColor(status);
              final staffName = (data['staffName'] ?? 'Χωρίς επιλογή').toString();
              final storeName = (data['storeName'] ?? '').toString();
              final serviceName = (data['serviceName'] ?? '').toString();
              final date = (data['date'] ?? '').toString();
              final displayDate = _formatGreekDateFromIso(date);
              final time = (data['time'] ?? '').toString();

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: PremiumSurface(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 144,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(ECutRadius.lg),
                            bottomLeft: Radius.circular(ECutRadius.lg),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      storeName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  PremiumStatusPill(label: _statusText(status), color: color),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.spa_rounded, size: 17, color: ECutColors.muted),
                                  const SizedBox(width: 7),
                                  Expanded(child: Text(serviceName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ECutColors.ink))),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline_rounded, size: 17, color: ECutColors.muted),
                                  const SizedBox(width: 7),
                                  Expanded(child: Text('Με: $staffName', style: Theme.of(context).textTheme.bodyMedium)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 17, color: ECutColors.muted),
                                  const SizedBox(width: 7),
                                  Text('$displayDate • $time', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ECutColors.plum)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          },
        ),
      ),
    );
  }
}
/// ---------------- ΟΘΟΝΗ ΑΝΑΖΗΤΗΣΗΣ (SEARCH SCREEN) ----------------
class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double _readRating(Map<String, dynamic> data) {
    final raw = data['rating'];
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '') ?? 0.0;
  }

  List<dynamic> _readServices(Map<String, dynamic> data) {
    final raw = data['services'];
    return raw is List ? raw : <dynamic>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(title: const Text('Αναζήτηση')),
      body: PremiumAppBackground(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: PremiumSurface(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                cursorColor: ECutColors.plum,
                style: const TextStyle(color: ECutColors.ink, fontSize: 16, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Αναζήτησε κατάστημα ή υπηρεσία',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: const Icon(Icons.search_rounded, color: ECutColors.plum),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase().trim()),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stores').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final allStores = snapshot.data!.docs;
                final filteredStores = allStores.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final services = _readServices(data).join(' ').toLowerCase();
                  return _searchQuery.isEmpty || name.contains(_searchQuery) || services.contains(_searchQuery);
                }).toList();

                if (filteredStores.isEmpty) {
                  return const PremiumEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Δεν βρέθηκε αποτέλεσμα',
                    message: 'Δοκίμασε διαφορετική λέξη-κλειδί ή αναζήτησε με όνομα υπηρεσίας.',
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                  itemCount: filteredStores.length,
                  itemBuilder: (context, index) {
                    final data = filteredStores[index].data() as Map<String, dynamic>;
                    final name = (data['name'] ?? 'Άγνωστο Μαγαζί').toString();
                    final image = (data['photoUrl'] ?? 'https://via.placeholder.com/600x400').toString();
                    final rating = _readRating(data);
                    final services = _readServices(data);

                    return PremiumStoreCard(
                      name: name,
                      imageUrl: image,
                      rating: rating,
                      subtitle: services.isEmpty ? 'Συνεργάτης ομορφιάς & wellness' : services.take(3).join(' • '),
                      compact: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreServicesScreen(storeName: name, services: services),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}
/// ---------------- ΝΕΑ ΟΘΟΝΗ: ΤΙΜΟΚΑΤΑΛΟΓΟΣ (StoreServicesScreen) ----------------
class StoreServicesScreen extends StatelessWidget {
  final String storeName;
  final List<dynamic> services;

  const StoreServicesScreen({
    super.key,
    required this.storeName,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> catalog = {
      'Κούρεμα': {'price': '15€', 'duration': '45 λεπτά', 'icon': Icons.content_cut},
      'Ξύρισμα': {'price': '10€', 'duration': '30 λεπτά', 'icon': Icons.face},
      'Βαφή': {'price': '25€', 'duration': '60 λεπτά', 'icon': Icons.color_lens},
      'Περιποίηση': {'price': '20€', 'duration': '30 λεπτά', 'icon': Icons.spa},
      'Χτένισμα': {'price': '12€', 'duration': '20 λεπτά', 'icon': Icons.brush},
    };

    return Scaffold(
      backgroundColor: ECutColors.ivory,
      appBar: AppBar(title: const Text('Τιμοκατάλογος')),
      body: PremiumAppBackground(
        child: services.isEmpty
          ? const PremiumEmptyState(
              icon: Icons.spa_outlined,
              title: 'Δεν βρέθηκαν υπηρεσίες',
              message: 'Το κατάστημα δεν έχει δηλώσει ακόμα τιμοκατάλογο.',
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
              itemCount: services.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: PremiumHeroPanel(
                      title: storeName,
                      subtitle: 'Διάλεξε υπηρεσία και συνέχισε με επαγγελματία και ώρα.',
                      icon: Icons.menu_book_rounded,
                    ),
                  );
                }

                final serviceName = services[index - 1].toString();
                final details = catalog[serviceName] ?? {'price': '-', 'duration': '-', 'icon': Icons.auto_awesome};

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(ECutRadius.lg),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ECutRadius.lg),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectStaffScreen(storeName: storeName, serviceName: serviceName),
                          ),
                        );
                      },
                      child: PremiumSurface(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: ECutColors.porcelain,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: SizedBox(
                                width: 54,
                                height: 54,
                                child: Icon(details['icon'] as IconData, color: ECutColors.plum),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(serviceName, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_rounded, size: 15, color: ECutColors.muted),
                                      const SizedBox(width: 4),
                                      Text(details['duration'].toString(), style: Theme.of(context).textTheme.bodyMedium),
                                      const SizedBox(width: 14),
                                      const Icon(Icons.euro_rounded, size: 15, color: ECutColors.muted),
                                      const SizedBox(width: 4),
                                      Text(details['price'].toString(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ECutColors.plum)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: ECutColors.plum,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Text('Επιλογή', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
