import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker_task_app/data/data.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.error) {}
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _EmailInput(),
          SizedBox(height: 8.0),
          _PasswordInput(),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<SignUpCubit>().emailChanged(email);
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (password) {
            context.read<SignUpCubit>().passwordChanged(password);
          },
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignUpStatus.submitting
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45.0),
                ),
                onPressed: () {
                  context
                      .read<SignUpCubit>()
                      .signUp()
                      .then((value) => Navigator.of(context).pop());
                },
                child: const Text('Sign Up'),
              );
      },
    );
  }
}
