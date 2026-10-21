import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';

/// Data transfer object serializing [PrescriptionEntity] to and from JSON.
class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.imagePath,
    required super.status,
    required super.uploadedAt,
    super.doctorNotes,
    super.patientNotes,
  });

  /// Deserializes a JSON map into a [PrescriptionModel].
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      imagePath: json['image_path'] as String,
      status: _statusFromString(json['status'] as String?),
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      doctorNotes: json['doctor_notes'] as String?,
      patientNotes: json['patient_notes'] as String?,
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'status': status.name,
      'uploaded_at': uploadedAt.toIso8601String(),
      'doctor_notes': doctorNotes,
      'patient_notes': patientNotes,
    };
  }

  /// Converts a pure domain [PrescriptionEntity] into a [PrescriptionModel].
  factory PrescriptionModel.fromEntity(PrescriptionEntity entity) {
    return PrescriptionModel(
      id: entity.id,
      imagePath: entity.imagePath,
      status: entity.status,
      uploadedAt: entity.uploadedAt,
      doctorNotes: entity.doctorNotes,
      patientNotes: entity.patientNotes,
    );
  }

  static PrescriptionStatus _statusFromString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'approved' => PrescriptionStatus.approved,
      'rejected' => PrescriptionStatus.rejected,
      _ => PrescriptionStatus.pending,
    };
  }
}
