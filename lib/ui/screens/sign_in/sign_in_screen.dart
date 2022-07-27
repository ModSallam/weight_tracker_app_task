import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker_task_app/data/data.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';
import 'package:weight_tracker_task_app/ui/ui.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SignInScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (_) => SignInCubit(context.read<AuthRepository>()),
          child: const SignInForm(),
        ),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.error) {}
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _EmailInput(),
          SizedBox(height: 8.0),
          _PasswordInput(),
          SizedBox(height: 20.0),
          _SignInButton(),
          SizedBox(height: 8.0),
          _SignUpButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<SignInCubit>().emailChanged(email);
          },
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (password) {
            context.read<SignInCubit>().passwordChanged(password);
          },
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignInStatus.submitting
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45.0),
                ),
                onPressed: () {
                  context.read<SignInCubit>().signIn();
                },
                child: const Text('Sign In'),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45.0),
      ),
      onPressed: () => Navigator.of(context).push<void>(SignUpScreen.route()),
      child: const Text('Don\'t have account? Sign Up'),
    );
  }
}
