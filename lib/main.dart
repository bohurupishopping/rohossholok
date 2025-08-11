import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'core/theme.dart';
import 'core/constants.dart';
import 'routes/app_router.dart';

import 'services/cache_service.dart';
import 'services/wordpress_api_service.dart';
import 'providers/posts_cubit.dart';
import 'providers/categories_cubit.dart';
import 'providers/pages_cubit.dart';
import 'providers/navigation_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences for caching
  await SharedPreferences.getInstance();
  
  // Initialize cache service
  final cacheService = CacheService();
  await cacheService.init();
  
  runApp(RohossholokApp(cacheService: cacheService));
}

/// Main application widget
class RohossholokApp extends StatelessWidget {
  final CacheService cacheService;
  
  const RohossholokApp({super.key, required this.cacheService});
  
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Provide Dio instance for HTTP requests
        RepositoryProvider<Dio>(
          create: (context) => Dio(
            BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )..interceptors.addAll([
            LogInterceptor(
              requestBody: true,
              responseBody: true,
              logPrint: (object) => debugPrint(object.toString()),
            ),
          ]),
        ),
        
        // Provide Cache service
        RepositoryProvider<CacheService>(
          create: (context) => cacheService,
        ),
        
        // Provide WordPress API service
        RepositoryProvider<WordPressApiService>(
          create: (context) => WordPressApiService(
            context.read<Dio>(),
            context.read<CacheService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Navigation Cubit
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          
          // Posts Cubit
          BlocProvider<PostsCubit>(
          create: (context) => PostsCubit(
            context.read<WordPressApiService>(),
          ),
        ),
          
          // Categories Cubit
          BlocProvider<CategoriesCubit>(
          create: (context) => CategoriesCubit(
            context.read<WordPressApiService>(),
          ),
        ),
          
          // Pages Cubit
          BlocProvider<PagesCubit>(
          create: (context) => PagesCubit(
            context.read<WordPressApiService>(),
          ),
        ),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          
          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          
          // Router configuration
          routerConfig: AppRouter.router,
        
          // Localization configuration
          locale: const Locale('bn', 'BD'), // Bengali (Bangladesh)
          supportedLocales: const [
            Locale('bn', 'BD'), // Bengali
            Locale('en', 'US'), // English
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Builder for global configurations
          builder: (context, child) {
            return MediaQuery(
              // Ensure text scaling doesn't break the UI
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.2,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

/// Global error handler widget
class GlobalErrorHandler extends StatelessWidget {
  final Widget child;
  
  const GlobalErrorHandler({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// App lifecycle observer
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('App inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('App paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('App detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('App hidden');
        break;
    }
  }
}