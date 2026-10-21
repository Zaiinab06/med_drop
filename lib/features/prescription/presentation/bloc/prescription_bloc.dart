import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/prescription/domain/usecases/get_prescriptions_usecase.dart';
import 'package:med_drop/features/prescription/domain/usecases/upload_prescription_usecase.dart';
import 'package:med_drop/features/prescription/presentation/bloc/prescription_event.dart';
import 'package:med_drop/features/prescription/presentation/bloc/prescription_state.dart';

/// Manages state and media workflows for prescription capture and upload.
class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final UploadPrescriptionUseCase uploadPrescriptionUseCase;
  final GetPrescriptionsUseCase getPrescriptionsUseCase;
  final ImagePicker imagePicker;

  PrescriptionBloc({
    required this.uploadPrescriptionUseCase,
    required this.getPrescriptionsUseCase,
    required this.imagePicker,
  }) : super(const PrescriptionInitial()) {
    on<PickImageFromCameraEvent>(_onPickFromCamera);
    on<PickImageFromGalleryEvent>(_onPickFromGallery);
    on<SubmitPrescriptionEvent>(_onSubmitPrescription);
    on<FetchPrescriptionsEvent>(_onFetchPrescriptions);
    on<ClearSelectedImageEvent>(_onClearSelectedImage);
  }

  // ── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onPickFromCamera(
    PickImageFromCameraEvent event,
    Emitter<PrescriptionState> emit,
  ) async {
    try {
      final picked = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
      );

      if (picked != null) {
        emit(PrescriptionImageSelected(File(picked.path)));
      }
    } catch (e) {
      emit(PrescriptionError('Failed to capture photo from camera: $e'));
    }
  }

  Future<void> _onPickFromGallery(
    PickImageFromGalleryEvent event,
    Emitter<PrescriptionState> emit,
  ) async {
    try {
      final picked = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );

      if (picked != null) {
        emit(PrescriptionImageSelected(File(picked.path)));
      }
    } catch (e) {
      emit(PrescriptionError('Failed to select image from gallery: $e'));
    }
  }

  Future<void> _onSubmitPrescription(
    SubmitPrescriptionEvent event,
    Emitter<PrescriptionState> emit,
  ) async {
    emit(const PrescriptionUploading(0.3));

    final result = await uploadPrescriptionUseCase(
      UploadPrescriptionParams(
        file: event.file,
        patientNotes: event.patientNotes,
      ),
    );

    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescription) => emit(PrescriptionSuccess(prescription)),
    );
  }

  Future<void> _onFetchPrescriptions(
    FetchPrescriptionsEvent event,
    Emitter<PrescriptionState> emit,
  ) async {
    final result = await getPrescriptionsUseCase(const NoParams());

    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescriptions) => emit(PrescriptionHistoryLoaded(prescriptions)),
    );
  }

  void _onClearSelectedImage(
    ClearSelectedImageEvent event,
    Emitter<PrescriptionState> emit,
  ) {
    emit(const PrescriptionInitial());
  }
}
