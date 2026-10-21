import 'dart:io';
import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';

/// Contract defining all prescription operations in the domain layer.
abstract interface class PrescriptionRepository {
  /// Uploads and registers a new prescription image.
  ///
  /// [file] – The raw or compressed prescription image file.
  /// [patientNotes] – Optional instructions from the patient for the pharmacist.
  Future<Either<Failure, PrescriptionEntity>> uploadPrescription({
    required File file,
    String? patientNotes,
  });

  /// Retrieves the history of uploaded prescriptions for the current user.
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptionHistory();
}
