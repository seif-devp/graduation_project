import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/remore_source.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/repo.dart';
import '../cubit/seeker_application_cubit.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    final cubit = context.read<SeekerApplicationCubit>();

    cubit.getMyApplications();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        cubit.getMyApplications(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SeekerApplicationCubit(
        SeekerApplicationRepoImpl(
          SeekerApplicationRemoteDataSource(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Applications'),
        ),
        body: BlocBuilder<SeekerApplicationCubit, SeekerApplicationState>(
          builder: (context, state) {
            final cubit = context.read<SeekerApplicationCubit>();

            if (state is SeekerApplicationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SeekerApplicationError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (cubit.applications.isEmpty) {
              return const Center(
                child: Text('No applications yet'),
              );
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: cubit.applications.length,
              itemBuilder: (context, index) {
                final item = cubit.applications[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.jobTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(item.companyName),
                        const SizedBox(height: 8),
                        Text('Status: ${item.status}'),
                        const SizedBox(height: 8),
                        Text(
                          'AI Match: ${item.aiMatchScore}%',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}