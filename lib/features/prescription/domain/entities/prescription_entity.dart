import 'package:equatable/equatable.dart';

/// Review and verification status of an uploaded prescription.
enum PrescriptionStatus {
  /// Awaiting pharmacist review.
  pending,

  /// Verified and approved by the pharmacy team.
  approved,

  /// Rejected due to illegibility, expiry, or invalid doctor credentials.
  rejected,
}

/// Pure domain entity representing a prescription uploaded by a patient.
class PrescriptionEntity extends Equatable {
  /// Unique identifier (UUID).
  final String id;

  /// Local or remote URL/path to the prescription image.
  final String imagePath;

  /// Current verification status.
  final PrescriptionStatus status;

  /// Timestamp when the prescription was captured and submitted.
  final DateTime uploadedAt;

  /// Optional clinical instructions or review comments from the pharmacist.
  final String? doctorNotes;

  /// Optional notes or special instructions provided by the patient.
  final String? patientNotes;

  const PrescriptionEntity({
    required this.id,
    required this.imagePath,
    required this.status,
    required this.uploadedAt,
    this.doctorNotes,
    this.patientNotes,
  });

  // ── Status Helpers ────────────────────────────────────────────────────────

  bool get isPending => status == PrescriptionStatus.pending;
  bool get isApproved => status == PrescriptionStatus.approved;
  bool get isRejected => status == PrescriptionStatus.rejected;

  @override
  List<Object?> get props => [
        id,
        imagePath,
        status,
        uploadedAt,
        doctorNotes,
        patientNotes,
      ];
}
