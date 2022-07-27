import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker_task_app/data/data.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const AddEntryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (_) => WeightCubit(context.read<WeightRepository>()),
          child: const AddEntryForm(),
        ),
      ),
    );
  }
}

class AddEntryForm extends StatelessWidget {
  const AddEntryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeightCubit, WeightState>(
      listener: (context, state) {
        if (state.status == WeightStatus.error) {}
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _WeightInput(),
          SizedBox(height: 20.0),
          _AddWeightButton(),
        ],
      ),
    );
  }
}

class _WeightInput extends StatelessWidget {
  const _WeightInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightCubit, WeightState>(
      buildWhen: (previous, current) => previous.weight != current.weight,
      builder: (context, state) {
        return TextField(
          onChanged: (weight) {
            context.read<WeightCubit>().weightChanged(weight);
          },
          decoration: const InputDecoration(
            labelText: 'Weight',
          ),
        );
      },
    );
  }
}

class _AddWeightButton extends StatelessWidget {
  const _AddWeightButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightCubit, WeightState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == WeightStatus.submitting
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45.0),
                ),
                onPressed: () {
                  context.read<WeightCubit>().addWeight().then(
                        (value) => Navigator.of(context).pop(),
                      );
                },
                child: const Text('Add Weight'),
              );
      },
    );
  }
}
