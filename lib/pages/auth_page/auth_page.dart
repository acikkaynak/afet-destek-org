import 'package:deprem_destek/data/repository/auth_repository.dart';
import 'package:deprem_destek/pages/auth_page/state/auth_cubit.dart';
import 'package:deprem_destek/pages/auth_page/state/auth_state.dart';
import 'package:deprem_destek/pages/my_demand_page/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage._();
  static Future<void> show(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) {
          return BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
            child: const AuthPage._(),
          );
        },
      ),
    );

    if (result != null && result) {
      // TODO(enes): push my demands page
    }
  }

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // TODO(enes): refactor to use reactive_forms

  // ignore: unused_field, prefer_final_fields
  bool _kvkkAccepted = false;
  String _number = '';
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isFirstStep = authState.status == AuthStateStatus.initial ||
        authState.status == AuthStateStatus.smsFailure ||
        authState.status == AuthStateStatus.sendingSms;

    final isLoading = authState.status == AuthStateStatus.sendingSms ||
        authState.status == AuthStateStatus.verifyingCode;

    final isButtonEnabled = (isFirstStep && _number.length > 8) ||
        (!isFirstStep && _code.isNotEmpty);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.authorized) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                onChanged: (number) => setState(() => _number = number),
              ),
              if (!isFirstStep) ...[
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (code) => setState(() => _code = code),
                )
              ],
              // implement kvkk

              if (authState.status == AuthStateStatus.smsFailure) ...[
                const _AuthErrorMessage('SMS gönderme başarısız')
              ],
              if (authState.status ==
                  AuthStateStatus.codeVerificationFailure) ...[
                const _AuthErrorMessage('Kod doğrulama başarısız')
              ],

              const SizedBox(height: 16),

              if (isLoading) ...[
                const Loader(),
              ] else ...[
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          final cubit = context.read<AuthCubit>();
                          if (isFirstStep) {
                            cubit.sendSms(number: _number);
                          } else {
                            cubit.verifySMSCode(code: _code);
                          }
                        }
                      : null,
                  child: const Text('Devam'),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthErrorMessage extends StatelessWidget {
  const _AuthErrorMessage(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ColoredBox(color: Colors.red, child: Text(message)),
    );
  }
}
