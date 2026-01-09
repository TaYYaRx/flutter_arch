import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DeleteStatus { idle, deleting, success, error }

class DeleteState {
  final DeleteStatus status;
  final String? message;

  const DeleteState({required this.status, this.message});

  const DeleteState.idle() : this(status: DeleteStatus.idle);
  const DeleteState.deleting() : this(status: DeleteStatus.deleting);
  const DeleteState.success() : this(status: DeleteStatus.success);
  const DeleteState.error(String msg)
    : this(status: DeleteStatus.error, message: msg);
}

final deleteProjeStateProvider = StateProvider<DeleteState>(
  (ref) => const DeleteState.idle(),
);
