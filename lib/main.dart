import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:read_the_label/config/env_config.dart';
import 'package:read_the_label/providers/connectivity_provider.dart';
import 'package:read_the_label/repositories/ai_repository.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/services/auth_service.dart';
import 'package:read_the_label/services/connectivity_service.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/viewmodels/auth_view_model.dart';
import 'package:read_the_label/viewmodels/daily_intake_view_model.dart';
import 'package:read_the_label/viewmodels/meal_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/product_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/screens/auth_page.dart';
import 'package:read_the_label/views/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_the_label/services/theme_service.dart';
import 'package:read_the_label/services/language_service.dart';
import 'package:read_the_label/viewmodels/theme_view_model.dart';
import 'package:read_the_label/viewmodels/language_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:read_the_label/l10n/app_localizations.dart';
import 'package:read_the_label/l10n/app_localizations_delegate.dart';
import 'package:read_the_label/services/pin_service.dart';
import 'package:read_the_label/viewmodels/pin_view_model.dart';
import 'package:read_the_label/views/screens/pin_verification_screen.dart';

class MyAppLoader extends StatelessWidget {
  final ThemeService themeService;
  final LanguageService languageService;
  final PinService pinService;

  const MyAppLoader({
    super.key,
    required this.themeService,
    required this.languageService,
    required this.pinService,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FutureBuilder(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final user = snapshot.data;
        final userId = user?.id ?? 'guest';
        return MyApp(
          userId: userId,
          themeService: themeService,
          languageService: languageService,
          pinService: pinService,
        );
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  await EnvConfig.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider<ThemeService>(
          create: (_) => ThemeService(prefs),
        ),
        Provider<LanguageService>(
          create: (_) => LanguageService(prefs),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(prefs),
        ),
        Provider<PinService>(
          create: (_) => PinService(prefs),
        ),
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (context) => ConnectivityProvider(
            context.read<ConnectivityService>(),
          ),
        ),
        Provider<AiRepository>(
          create: (_) => AiRepository(),
        ),
        Provider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        ChangeNotifierProvider<UiViewModel>(
          create: (context) => UiViewModel(),
        ),
        ChangeNotifierProvider<MealAnalysisViewModel>(
          create: (context) => MealAnalysisViewModel(
            aiRepository: context.read<AiRepository>(),
            uiProvider: context.read<UiViewModel>(),
            connectivityService: context.read<ConnectivityService>(),
          ),
        ),
        ChangeNotifierProvider<DailyIntakeViewModel>(
          create: (context) => DailyIntakeViewModel(
            storageRepository: context.read<StorageRepository>(),
            uiProvider: context.read<UiViewModel>(),
          ),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthService>(),
            context.read<ConnectivityService>(),
          ),
        ),
        ChangeNotifierProxyProvider<UiViewModel, ProductAnalysisViewModel>(
          create: (context) => ProductAnalysisViewModel(
            aiRepository: context.read<AiRepository>(),
            uiProvider: context.read<UiViewModel>(),
          ),
          update: (context, uiViewModel, previous) =>
              previous!..uiProvider = uiViewModel,
        ),
      ],
      child: Builder(
        builder: (context) => MyAppLoader(
          themeService: context.read<ThemeService>(),
          languageService: context.read<LanguageService>(),
          pinService: context.read<PinService>(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String userId;
  final ThemeService themeService;
  final LanguageService languageService;
  final PinService pinService;

  const MyApp({
    super.key,
    required this.userId,
    required this.themeService,
    required this.languageService,
    required this.pinService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(themeService, userId),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageViewModel(languageService, userId),
        ),
        ChangeNotifierProvider(
          create: (_) => PinViewModel(pinService, userId),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) {
            final authVM = AuthViewModel(
              Provider.of<AuthService>(context, listen: false),
              Provider.of<ConnectivityService>(context, listen: false),
            );
            authVM.pinService = pinService;
            return authVM;
          },
        ),
      ],
      child: Consumer3<ThemeViewModel, LanguageViewModel, PinViewModel>(
        builder: (context, themeVM, languageVM, pinVM, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                secondary: Colors.blueAccent,
                onSecondary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                background: Colors.white,
                onBackground: Colors.black,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blue,
                onPrimary: Colors.white,
                secondary: Colors.blueAccent,
                onSecondary: Colors.white,
                surface: Colors.grey[900]!,
                onSurface: Colors.white,
                background: Colors.black,
                onBackground: Colors.white,
              ),
            ),
            themeMode: themeVM.themeMode,
            locale: languageVM.locale,
            supportedLocales: LanguageService.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: pinVM.isPinEnabled
                ? const PinVerificationScreen()
                : const HomePage(),
            routes: {
              '/home': (context) => const HomePage(),
              '/auth': (context) => const AuthPage(),
            },
          );
        },
      ),
    );
  }
}
