import 'package:deprem_destek/data/repository/auth_repository.dart';
import 'package:deprem_destek/data/repository/demands_repository.dart';
import 'package:deprem_destek/pages/auth_page/auth_page.dart';
import 'package:deprem_destek/pages/demands_page/state/demands_cubit.dart';
import 'package:deprem_destek/pages/demands_page/widgets/demand_card.dart';
import 'package:deprem_destek/pages/demands_page/widgets/demand_filter_popup.dart';
import 'package:deprem_destek/pages/my_demand_page/my_demand_page.dart';
import 'package:deprem_destek/shared/state/app_cubit.dart';
import 'package:deprem_destek/shared/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemandsPage extends StatelessWidget {
  const DemandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = context.read<AppCubit>().state.whenOrNull(
          loaded: (currentLocation, demandCategories) => currentLocation,
        );

    if (currentLocation == null) {
      return const Scaffold(body: Loader());
    }

    return BlocProvider<DemandsCubit>(
      create: (context) => DemandsCubit(
        demandsRepository: context.read<DemandsRepository>(),
        currentLocation: currentLocation.geometry!.location,
      ),
      child: StreamBuilder<User?>(
        stream: context.read<AuthRepository>().userStream,
        builder: (context, snapshot) {
          final authorized = snapshot.data != null;
          return _DemandsPageView(isAuthorized: authorized);
        },
      ),
    );
  }
}

class _DemandsPageView extends StatefulWidget {
  const _DemandsPageView({required this.isAuthorized});
  final bool isAuthorized;

  @override
  State<_DemandsPageView> createState() => _DemandsPageViewState();
}

class _DemandsPageViewState extends State<_DemandsPageView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldLoadNext = _scrollController.offset >
          _scrollController.position.maxScrollExtent * 0.9;
      if (shouldLoadNext) {
        context.read<DemandsCubit>().loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DemandsCubit>().state;

    final demands = state.demands;

    if (demands == null) {
      return const Scaffold(body: Loader());
    }
    // const Scaffold(body: Center(child: Text('todo failure page')));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => DemandFilterPopup.show(context),
          ),
        ],
      ),
      body: demands.isEmpty
          ? const Center(child: Text('Sonuç bulunamadı'))
          : Stack(
              fit: StackFit.expand,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: demands.length,
                  itemBuilder: (context, index) {
                    final demand = demands[index];
                    return Column(
                      children: [
                        DemandCard(demand: demand),
                        if (index == demands.length - 1) ...[
                          if (state.status.maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          )) ...[
                            const SizedBox(height: 16),
                            const Loader(),
                          ],
                          const SizedBox(height: 64)
                        ]
                      ],
                    );
                  },
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton(
                    onPressed: !widget.isAuthorized
                        ? () => AuthPage.show(context)
                        : () => MyDemandPage.show(context),
                    child: const Text(
                      'Destek Taleplerim',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
