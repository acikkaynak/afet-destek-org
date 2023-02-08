import 'package:deprem_destek/data/api/demands_api_client.dart';
import 'package:deprem_destek/data/repository/auth_repository.dart';
import 'package:deprem_destek/data/repository/demands_repository.dart';
import 'package:deprem_destek/data/repository/location_repository.dart';
import 'package:deprem_destek/pages/app_load_failure_page/app_load_failure_page.dart';
import 'package:deprem_destek/pages/demands_page/demands_page.dart';
import 'package:deprem_destek/pages/introduction_page/introduction_page.dart';
import 'package:deprem_destek/shared/state/app_cubit.dart';
import 'package:deprem_destek/shared/state/app_state.dart';
import 'package:deprem_destek/shared/theme/theme.dart';
import 'package:deprem_destek/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepremDestekApp extends StatefulWidget {
  const DepremDestekApp({super.key});

  @override
  State<DepremDestekApp> createState() => _DepremDestekAppState();
}

class _DepremDestekAppState extends State<DepremDestekApp> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<DemandsRepository>(
          create: (context) => DemandsRepository(
            demandsApiClient: DemandsApiClient(),
          ),
        ),
        RepositoryProvider<LocationRepository>(
          create: (context) => LocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(
            create: (context) => AppCubit(
              demandsRepository: context.read<DemandsRepository>(),
              locationRepository: context.read<LocationRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return MaterialApp(
              theme: AppTheme.theme(context),
              debugShowCheckedModeBanner: false,
              home: state.when(
                introduction: () => const IntroductionPage(),
                loaded: (_, __) => const DemandsPage(),
                failed: () => const AppLoadFailurePage(),
                loading: () => const Scaffold(body: Loader()),
              ) as Widget,
              builder: (context, child) {
                final width = MediaQuery.of(context).size.width;
                return Center(
                  child: SizedBox(
                    width: width.clamp(0, 700),
                    child: child,
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
