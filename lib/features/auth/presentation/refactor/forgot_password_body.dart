import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.email_outlined,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LangKeys.resetPassword.tr(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LangKeys.resetPasswordSubtitle.tr(),
                      style: TextStyle(color: Theme.of(context).hintColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    if (state.resetSent)
                      Text(
                        LangKeys.resetLinkSent.tr(),
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )
                    else ...[
                      AppTextField(
                        label: LangKeys.email.tr(),
                        hint: 'you@example.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: LangKeys.sendResetLink.tr(),
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          context.read<AuthCubit>().sendPasswordReset(
                                _emailCtrl.text,
                              );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: Text(LangKeys.login.tr()),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

