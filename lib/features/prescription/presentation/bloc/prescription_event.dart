import 'dart:io';

import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [PrescriptionBloc].
sealed class PrescriptionEvent extends Equatable {
  const PrescriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to capture an image directly using the device camera.
final class PickImageFromCameraEvent extends PrescriptionEvent {
  const PickImageFromCameraEvent();
}

/// Dispatched to select a prescription image from the gallery / photo library.
final class PickImageFromGalleryEvent extends PrescriptionEvent {
  const PickImageFromGalleryEvent();
}

/// Dispatched to submit and upload the selected prescription file.
final class SubmitPrescriptionEvent extends PrescriptionEvent {
  final File file;
  final String? patientNotes;

  const SubmitPrescriptionEvent({
    required this.file,
    this.patientNotes,
  });

  @override
  List<Object?> get props => [file.path, patientNotes];
}

/// Dispatched to fetch all past prescriptions uploaded by the user.
final class FetchPrescriptionsEvent extends PrescriptionEvent {
  const FetchPrescriptionsEvent();
}

/// Dispatched to remove or reset the selected prescription image.
final class ClearSelectedImageEvent extends PrescriptionEvent {
  const ClearSelectedImageEvent();
}
