import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          context.go(AppRoutes.dashboard);
        } else if (state.status == AuthStatus.error && state.errorKey != null) {
          showToast(state.errorKey!.tr(), isError: true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
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
                    child:
                        const Icon(Icons.login, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LangKeys.welcomeBack.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LangKeys.loginSubtitle.tr(),
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: LangKeys.email.tr(),
                    hint: 'you@example.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: LangKeys.password.tr(),
                    controller: _passwordCtrl,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: Text(
                        LangKeys.forgotPassword.tr(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: LangKeys.loginButton.tr(),
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          context.read<AuthCubit>().signIn(
                                _emailCtrl.text,
                                _passwordCtrl.text,
                              );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LangKeys.noAccount.tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.register),
                        child: Text(LangKeys.createOne.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
