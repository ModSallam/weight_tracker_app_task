import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker_task_app/data/data.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';
import 'package:weight_tracker_task_app/ui/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppBloc>().add(AppSignOutRequested());
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Welcome ${user.email}'),
                const _AddWeightButton(),
              ],
            ),
            const _WeightEntriesData(),
          ],
        ),
      ),
    );
  }
}

class _WeightEntriesData extends StatelessWidget {
  const _WeightEntriesData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder(
      stream: firestore
          .collection('weight')
          .doc(auth.currentUser!.uid)
          .collection('entries')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final List<WeightModel> data = snapshot.data!.docs
                    .map((element) => WeightModel.fromSnap(element))
                    .toList();

                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(data[index].weight),
                  subtitle: Text('${data[index].date}'),
                );
              }),
        );
      },
    );
  }
}

class _AddWeightButton extends StatelessWidget {
  const _AddWeightButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(
        AddEntryScreen.route(),
      ),
      child: const Text('Add Weight'),
    );
  }
}
