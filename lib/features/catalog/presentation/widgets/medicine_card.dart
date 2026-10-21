import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_bloc.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_event.dart';

/// Modern medical card component displaying a medicine's details, stock status,
/// pricing in PKR, dosage information, and prescription requirements.
class MedicineCard extends StatelessWidget {
  final MedicineEntity medicine;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: medicine.requiresPrescription
              ? AppColors.warning.withValues(alpha: 0.25)
              : AppColors.divider,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          splashColor: AppColors.primaryLight.withValues(alpha: 0.12),
          highlightColor: AppColors.primaryLight.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Tags Row: Dosage/Strength & Prescription Badge ────────
                Row(
                  children: [
                    // Dosage form & strength badge
                    _buildDosageChip(),
                    const Spacer(),
                    // Prescription warning tag
                    if (medicine.requiresPrescription) ...[
                      _buildRxBadge(),
                      const SizedBox(width: 8),
                    ],
                    // Stock pill (In Stock / Out of Stock)
                    _buildStockBadge(),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Middle Section: Icon/Image + Name + Salt ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image or themed dosage-form icon
                    _buildLeadingThumbnail(),
                    const SizedBox(width: 14),
                    // Names & description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand Name
                          Text(
                            medicine.brandName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          // Salt / Generic Name
                          Text(
                            medicine.saltName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Availability note
                          Text(
                            medicine.isInStock
                                ? '${medicine.stockCount} units available'
                                : 'Currently unavailable',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: medicine.isInStock
                                  ? AppColors.textSecondary
                                  : AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Bottom Row: Price & Action ───────────────────────────────
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price per unit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'PKR ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              medicine.unitPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Add to cart / Request button
                    InkWell(
                      onTap: medicine.isInStock
                          ? () {
                              if (onAddToCart != null) {
                                onAddToCart!();
                              } else {
                                context
                                    .read<CartBloc>()
                                    .add(AddToCartEvent(medicine));
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Added ${medicine.brandName} to cart.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: AppColors.secondary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.radiusSm,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          : null,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: medicine.isInStock
                              ? AppColors.primary
                              : AppColors.divider,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: medicine.isInStock
                                  ? AppColors.textOnPrimary
                                  : AppColors.textDisabled,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: medicine.isInStock
                                  ? AppColors.textOnPrimary
                                  : AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Child Component Builders ────────────────────────────────────────────────

  Widget _buildDosageChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate-100
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Text(
        '${medicine.dosageForm} • ${medicine.strength}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryLight,
        ),
      ),
    );
  }

  Widget _buildRxBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 12,
            color: Color(0xFFB45309), // Amber-700
          ),
          SizedBox(width: 4),
          Text(
            'Rx Required',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockBadge() {
    final inStock = medicine.isInStock;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: inStock ? AppColors.successLight : AppColors.dangerLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: inStock ? AppColors.primary : AppColors.danger,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            inStock ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: inStock ? AppColors.primaryDark : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingThumbnail() {
    final image = medicine.imageUrl;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        child: CachedNetworkImage(
          imageUrl: image,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildIconBackdrop(),
          errorWidget: (_, __, ___) => _buildIconBackdrop(),
        ),
      );
    }
    return _buildIconBackdrop();
  }

  Widget _buildIconBackdrop() {
    final iconData = _iconForDosageForm(medicine.dosageForm);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: AppColors.primary,
          size: 26,
        ),
      ),
    );
  }

  IconData _iconForDosageForm(String form) {
    final lower = form.toLowerCase();
    if (lower.contains('inhaler')) return Icons.air_rounded;
    if (lower.contains('syrup') || lower.contains('liquid')) {
      return Icons.liquor_rounded;
    }
    if (lower.contains('injection')) return Icons.vaccines_rounded;
    if (lower.contains('capsule')) return Icons.medication_liquid_rounded;
    return Icons.medication_rounded;
  }
}
