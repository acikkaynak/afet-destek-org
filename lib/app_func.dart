import 'dart:async';
import 'dart:io';

import 'package:afet_destek/app.dart';
import 'package:afet_destek/shared/state/lang_cubit.dart';
import 'package:afet_destek/utils/logger/app_logger.dart';
import 'package:afet_destek/utils/observer/bloc_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

class AppFunc {
  static String baseUrl = '';

  static Future<void> startDev() => _start(
        url: 'https://us-central1-env-deprem-destek-org.cloudfunctions.net/',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAwga9Tzl9ODSGdVRNtw8lgAS5MoIl16Ck',
          appId: '1:643767075935:web:3cc9d6c4658af4ded7c7ea',
          messagingSenderId: '643767075935',
          projectId: 'env-deprem-destek-org',
          authDomain: 'env-deprem-destek-org.firebaseapp.com',
          storageBucket: 'env-deprem-destek-org.appspot.com',
          measurementId: 'G-G552720SJK',
        ),
        sentryDsn:
            'https://a472fdea96db4bd3b3ca80ce8583e9ba@o4504644634607616.ingest.sentry.io/4504651796381696',
        firebaseAppName: 'dev',
      );

  static Future<void> startProd() => _start(
        url: 'https://us-central1-deprem-destek-org.cloudfunctions.net/',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyASFP7KxEb8f1JbiDkXDzsj1-e7bPRoaw0',
          appId: '1:529071733784:web:dfa3729d7ed5c5494c976d',
          messagingSenderId: '529071733784',
          projectId: 'deprem-destek-org',
        ),
        sentryDsn:
            'https://bc941e7fb9ab4ae793bbd16c77844d29@o4504644634607616.ingest.sentry.io/4504644636246016',
        firebaseAppName: 'prod',
      );

  static void startLocalizedApp() {
    runApp(
      EasyLocalization(
        supportedLocales: AppLang.values.map((e) => e.locale).toList(),
        fallbackLocale: AppLang.values.first.locale,
        path: 'assets/translations',
        child: const DepremDestekApp(),
      ),
    );
  }

  static Future<void> _start({
    required FirebaseOptions options,
    required String sentryDsn,
    required String url,
    required String firebaseAppName,
  }) async {
    baseUrl = url;

    // TODO(adnanjpg): ios throws `Flutter - Unhandled Exception:
    // [core/duplicate-app]` error when passing options
    // https://github.com/acikkaynak/yardim-agi-flutter/issues/161
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: options,
      );
    } else {
      if (Platform.isIOS) {
        await Firebase.initializeApp();
      } else {
        await Firebase.initializeApp(
          name: firebaseAppName,
          options: options,
        );
      }
    }

    await SentryFlutter.init(
      (options) {
        options
          ..dsn = sentryDsn
          ..tracesSampleRate = 1.0
          ..reportPackages = false
          ..debug = false;
      },
      // catch Unhandled exceptions and errors

      appRunner: () => runZonedGuarded(
        () async {
          Bloc.observer = AppBlocObserver();
          // await MixPanelAnalytics.initMixPanelAnalytics();

          setPathUrlStrategy();

          WidgetsFlutterBinding.ensureInitialized();
          await EasyLocalization.ensureInitialized();

          startLocalizedApp();
        },
        (error, stackTrace) =>
            AppLoggerImpl.log.e(error.toString(), stackTrace),
      ),
    );
  }
}

enum AppType {
  dev,
  prod,
}
