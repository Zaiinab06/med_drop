import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';
import 'package:med_drop/features/prescription/presentation/bloc/prescription_bloc.dart';
import 'package:med_drop/features/prescription/presentation/bloc/prescription_event.dart';
import 'package:med_drop/features/prescription/presentation/bloc/prescription_state.dart';
import 'package:med_drop/injection_container.dart';

/// Screen enabling patients to capture or pick a doctor's prescription,
/// attach instructions, and submit it for pharmacy verification.
class UploadPrescriptionScreen extends StatelessWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<PrescriptionBloc>();
      return const _UploadPrescriptionView();
    } catch (_) {
      return BlocProvider<PrescriptionBloc>(
        create: (context) => sl<PrescriptionBloc>(),
        child: const _UploadPrescriptionView(),
      );
    }
  }
}

class _UploadPrescriptionView extends StatefulWidget {
  const _UploadPrescriptionView();

  @override
  State<_UploadPrescriptionView> createState() =>
      _UploadPrescriptionViewState();
}

class _UploadPrescriptionViewState extends State<_UploadPrescriptionView> {
  final TextEditingController _notesController = TextEditingController();
  File? _selectedFile;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionBloc, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionImageSelected) {
          setState(() => _selectedFile = state.file);
        } else if (state is PrescriptionInitial) {
          setState(() {
            _selectedFile = null;
            _notesController.clear();
          });
        } else if (state is PrescriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
            ),
          );
        } else if (state is PrescriptionSuccess) {
          _showSuccessModal(context, state.prescription);
        }
      },
      builder: (context, state) {
        final isUploading = state is PrescriptionUploading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Upload Prescription',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingHorizontal),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Medical Verification Instructions Banner ──────────────
                  _buildInstructionBanner(),
                  const SizedBox(height: 18),

                  // ── Image Preview or Picker Box ───────────────────────────
                  if (_selectedFile != null)
                    _buildImagePreview(context)
                  else
                    _buildEmptyPickerBox(context),

                  const SizedBox(height: 20),

                  // ── Camera & Gallery Action Buttons ───────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _buildMediaPickButton(
                          context: context,
                          label: 'Camera',
                          icon: Icons.camera_alt_rounded,
                          isPrimary: true,
                          onTap: isUploading
                              ? null
                              : () {
                                  context.read<PrescriptionBloc>().add(
                                        const PickImageFromCameraEvent(),
                                      );
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMediaPickButton(
                          context: context,
                          label: 'Gallery',
                          icon: Icons.photo_library_rounded,
                          isPrimary: false,
                          onTap: isUploading
                              ? null
                              : () {
                                  context.read<PrescriptionBloc>().add(
                                        const PickImageFromGalleryEvent(),
                                      );
                                },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Patient Instructions / Notes Field ────────────────────
                  _buildNotesField(isUploading),

                  const SizedBox(height: 28),

                  // ── Emerald 'Submit Prescription' CTA ─────────────────────
                  _buildSubmitButton(context, isUploading),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildInstructionBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valid Prescription Requirement',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Please ensure the doctor\'s name, stamp, clinic details, patient name, and prescription date are clearly legible.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPickerBox(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No prescription image selected',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Capture a photo or upload from device\n(Auto-compressed to under 1MB)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    final file = _selectedFile!;
    final fileSizeKb = (file.lengthSync() / 1024).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusMd),
                ),
                child: Image.file(
                  file,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    context
                        .read<PrescriptionBloc>()
                        .add(const ClearSelectedImageEvent());
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xCC1E293B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Image Ready',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const Spacer(),
                Text(
                  '$fileSizeKb KB',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPickButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppColors.primary : AppColors.surface,
        foregroundColor:
            isPrimary ? AppColors.textOnPrimary : AppColors.secondary,
        elevation: 0,
        side: isPrimary
            ? BorderSide.none
            : const BorderSide(color: AppColors.divider, width: 1.5),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
    );
  }

  Widget _buildNotesField(bool isUploading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pharmacist Instructions (Optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _notesController,
          enabled: !isUploading,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText:
                'e.g. Please provide syrup if tablets are unavailable, deliver by evening...',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textDisabled,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isUploading) {
    final hasFile = _selectedFile != null;

    return ElevatedButton(
      onPressed: (!hasFile || isUploading)
          ? null
          : () {
              context.read<PrescriptionBloc>().add(
                    SubmitPrescriptionEvent(
                      file: _selectedFile!,
                      patientNotes: _notesController.text,
                    ),
                  );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.divider,
        foregroundColor: AppColors.textOnPrimary,
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      child: isUploading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                ),
                SizedBox(width: 12),
                Text(
                  'Compressing & Uploading...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Submit Prescription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
    );
  }

  void _showSuccessModal(
    BuildContext context,
    PrescriptionEntity prescription,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Prescription Submitted!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reference #${prescription.id.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: Color(0xFFB45309),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Pending Pharmacist Review',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Our licensed pharmacy team will verify your prescription. You will receive an alert once medicines are approved and dispensed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context, prescription.id);
                    }
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
