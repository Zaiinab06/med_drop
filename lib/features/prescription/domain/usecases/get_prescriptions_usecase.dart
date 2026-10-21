import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';
import 'package:med_drop/features/prescription/domain/repositories/prescription_repository.dart';

/// Fetches the user's submitted prescription history.
class GetPrescriptionsUseCase
    implements UseCase<List<PrescriptionEntity>, NoParams> {
  final PrescriptionRepository repository;

  const GetPrescriptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> call(NoParams params) {
    return repository.getPrescriptionHistory();
  }
}
