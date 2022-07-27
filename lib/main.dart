import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker_task_app/app_bloc_observer.dart';
import 'package:weight_tracker_task_app/config/config.dart';
import 'package:weight_tracker_task_app/data/data.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';

Future<void> main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final AuthRepository authRepository = AuthRepository();
      final WeightRepository weightRepository = WeightRepository();
      runApp(WeightTrackerApp(
        authRepository: authRepository,
        weightRepository: weightRepository,
      ));
    },
    blocObserver: AppBlocObserver(),
  );
}

class WeightTrackerApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final WeightRepository _weightRepository;

  const WeightTrackerApp({
    Key? key,
    required AuthRepository authRepository,
    required WeightRepository weightRepository,
  })  : _authRepository = authRepository,
        _weightRepository = weightRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authRepository,
        ),
        RepositoryProvider.value(
          value: _weightRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(authRepository: _authRepository),
          ),
        ],
        child: const WeightTrackerAppView(),
      ),
    );
  }
}

class WeightTrackerAppView extends StatelessWidget {
  const WeightTrackerAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateWeightTrackerAppViewPages,
      ),
    );
  }
}
