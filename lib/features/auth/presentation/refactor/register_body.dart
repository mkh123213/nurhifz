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

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
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
                    child: const Icon(Icons.person_add,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LangKeys.registerTitle.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LangKeys.registerSubtitle.tr(),
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
                  const SizedBox(height: 16),
                  AppTextField(
                    label: LangKeys.confirmPassword.tr(),
                    controller: _confirmCtrl,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: LangKeys.registerButton.tr(),
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          if (_passwordCtrl.text != _confirmCtrl.text) {
                            showToast(LangKeys.errorPasswordsMismatch.tr(),
                                isError: true);
                            return;
                          }
                          context.read<AuthCubit>().register(
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
                        LangKeys.hasAccount.tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.login),
                        child: Text(LangKeys.login.tr()),
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
