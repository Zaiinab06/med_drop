import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';

/// Base class for all states emitted by [PrescriptionBloc].
sealed class PrescriptionState extends Equatable {
  const PrescriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state before an image is selected or action performed.
final class PrescriptionInitial extends PrescriptionState {
  const PrescriptionInitial();
}

/// State emitted when a prescription image has been chosen via camera or gallery.
final class PrescriptionImageSelected extends PrescriptionState {
  final File file;

  const PrescriptionImageSelected(this.file);

  @override
  List<Object?> get props => [file.path];
}

/// State emitted while the prescription is being compressed and uploaded.
final class PrescriptionUploading extends PrescriptionState {
  /// Upload progress from 0.0 to 1.0.
  final double progress;

  const PrescriptionUploading([this.progress = 0.5]);

  @override
  List<Object?> get props => [progress];
}

/// State emitted when the prescription upload succeeds.
final class PrescriptionSuccess extends PrescriptionState {
  final PrescriptionEntity prescription;

  const PrescriptionSuccess(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

/// State emitted when an error occurs during picking, validation, or upload.
final class PrescriptionError extends PrescriptionState {
  final String message;

  const PrescriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State emitted when past prescription history has been loaded.
final class PrescriptionHistoryLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;

  const PrescriptionHistoryLoaded(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}
