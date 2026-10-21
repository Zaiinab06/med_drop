import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';
import 'package:med_drop/features/prescription/domain/repositories/prescription_repository.dart';

/// Use case that orchestrates prescription validation and submission.
class UploadPrescriptionUseCase
    implements UseCase<PrescriptionEntity, UploadPrescriptionParams> {
  final PrescriptionRepository repository;

  const UploadPrescriptionUseCase(this.repository);

  @override
  Future<Either<Failure, PrescriptionEntity>> call(
    UploadPrescriptionParams params,
  ) async {
    if (!params.file.existsSync()) {
      return const Left(
        ValidationFailure('Selected prescription file does not exist.'),
      );
    }

    if (params.file.lengthSync() == 0) {
      return const Left(
        ValidationFailure('Prescription image file is empty.'),
      );
    }

    return repository.uploadPrescription(
      file: params.file,
      patientNotes: params.patientNotes?.trim(),
    );
  }
}

/// Input parameters for [UploadPrescriptionUseCase].
final class UploadPrescriptionParams extends Equatable {
  final File file;
  final String? patientNotes;

  const UploadPrescriptionParams({
    required this.file,
    this.patientNotes,
  });

  @override
  List<Object?> get props => [file.path, patientNotes];
}
