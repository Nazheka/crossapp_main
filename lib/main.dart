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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get userId (replace with actual logic if needed)
    final userId = 'guest';
    final themeService = Provider.of<ThemeService>(context, listen: false);
    final languageService = Provider.of<LanguageService>(context, listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(themeService, userId),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageViewModel(languageService, userId),
        ),
      ],
      child: Consumer2<ThemeViewModel, LanguageViewModel>(
        builder: (context, themeVM, languageVM, _) {
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
            home: FutureBuilder<bool>(
              future: Provider.of<AuthService>(context, listen: false).isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return snapshot.data == true ? const HomePage() : const AuthPage();
              },
            ),
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
