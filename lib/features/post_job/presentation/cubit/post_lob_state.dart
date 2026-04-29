import 'package:equatable/equatable.dart';

abstract class PostJobState extends Equatable {
  const PostJobState();

  @override
  List<Object> get props => [];
}

class PostJobInitial extends PostJobState {}

class PostJobLoading extends PostJobState {}

class PostJobSuccess extends PostJobState {}

class PostJobFailure extends PostJobState {
  final String errorMessage;
  const PostJobFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PostJobRequirementsUpdated extends PostJobState {
  final List<String> requirements;
  const PostJobRequirementsUpdated(this.requirements);

  @override
  List<Object> get props => [requirements];
}