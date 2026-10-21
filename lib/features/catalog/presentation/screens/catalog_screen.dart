import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';
import 'package:med_drop/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:med_drop/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:med_drop/features/catalog/presentation/bloc/catalog_state.dart';
import 'package:med_drop/features/catalog/presentation/widgets/catalog_search_bar.dart';
import 'package:med_drop/features/catalog/presentation/widgets/medicine_card.dart';
import 'package:med_drop/injection_container.dart';

/// Primary Catalog Screen displaying the inventory of available medicines.
///
/// Features:
/// - Reactive search with debouncing
/// - Filter chips (All, In Stock, Prescription Rx, OTC)
/// - Pull-to-refresh with cache bypass
/// - Smooth state transitions (Loading shimmers, Empty states, Error handling)
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogBloc>(
      create: (context) => sl<CatalogBloc>()..add(const LoadCatalogEvent()),
      child: const _CatalogView(),
    );
  }
}

class _CatalogView extends StatefulWidget {
  const _CatalogView();

  @override
  State<_CatalogView> createState() => _CatalogViewState();
}

enum _CatalogFilter { all, inStockOnly, prescriptionOnly, otcOnly }

class _CatalogViewState extends State<_CatalogView> {
  _CatalogFilter _activeFilter = _CatalogFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'Medicine Catalog',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Search & browse pharmaceutical items',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            tooltip: 'Force refresh catalog',
            onPressed: () {
              context
                  .read<CatalogBloc>()
                  .add(const LoadCatalogEvent(forceRefresh: true));
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search & Filter Bar Section ──────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingHorizontal,
                12,
                AppConstants.paddingHorizontal,
                10,
              ),
              color: AppColors.surface,
              child: Column(
                children: [
                  CatalogSearchBar(
                    onSearch: (query) {
                      context
                          .read<CatalogBloc>()
                          .add(SearchCatalogEvent(query));
                    },
                    onClear: () {
                      context
                          .read<CatalogBloc>()
                          .add(const ClearSearchEvent());
                    },
                  ),
                  const SizedBox(height: 10),
                  // Filter Chips
                  _buildFilterChips(),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),

            // ── Main Content Area ───────────────────────────────────────────
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  return switch (state) {
                    CatalogInitial() || CatalogLoading() =>
                      _buildLoadingSkeleton(),
                    CatalogLoaded(
                      medicines: final list,
                      isSearching: final isSearching,
                      query: final query,
                    ) =>
                      _buildLoadedList(context, list, isSearching, query),
                    CatalogEmpty(:final message) =>
                      _buildEmptyState(context, message),
                    CatalogError(:final message) =>
                      _buildErrorState(context, message),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter Chips Bar ────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _filterChip(
            label: 'All Items',
            filter: _CatalogFilter.all,
            icon: Icons.grid_view_rounded,
          ),
          const SizedBox(width: 8),
          _filterChip(
            label: 'In Stock',
            filter: _CatalogFilter.inStockOnly,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(width: 8),
          _filterChip(
            label: 'Prescription (Rx)',
            filter: _CatalogFilter.prescriptionOnly,
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(width: 8),
          _filterChip(
            label: 'Over-the-Counter (OTC)',
            filter: _CatalogFilter.otcOnly,
            icon: Icons.healing_rounded,
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required _CatalogFilter filter,
    required IconData icon,
  }) {
    final isSelected = _activeFilter == filter;
    return InkWell(
      onTap: () => setState(() => _activeFilter = filter),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loaded State ────────────────────────────────────────────────────────────

  Widget _buildLoadedList(
    BuildContext context,
    List<MedicineEntity> medicines,
    bool isSearching,
    String? query,
  ) {
    // Apply client-side quick filter
    final filtered = medicines.where((m) {
      return switch (_activeFilter) {
        _CatalogFilter.all => true,
        _CatalogFilter.inStockOnly => m.isInStock,
        _CatalogFilter.prescriptionOnly => m.requiresPrescription,
        _CatalogFilter.otcOnly => !m.requiresPrescription,
      };
    }).toList(growable: false);

    if (filtered.isEmpty) {
      return _buildEmptyFilterState();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        context
            .read<CatalogBloc>()
            .add(const LoadCatalogEvent(forceRefresh: true));
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppConstants.paddingHorizontal,
          14,
          AppConstants.paddingHorizontal,
          24,
        ),
        itemCount: filtered.length + 1, // +1 for summary header
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildResultsHeader(
              totalCount: filtered.length,
              isSearching: isSearching,
              query: query,
            );
          }

          final medicine = filtered[index - 1];
          return MedicineCard(
            medicine: medicine,
            onTap: () => _showMedicineDetails(context, medicine),
            onAddToCart: () => _handleAddToCart(context, medicine),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader({
    required int totalCount,
    required bool isSearching,
    String? query,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isSearching && query != null && query.isNotEmpty
                ? 'Search results for "$query"'
                : 'Available Medicines',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$totalCount ${totalCount == 1 ? "item" : "items"}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading Skeleton / Shimmer ──────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.paddingHorizontal),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitThreeBounce(
                  color: AppColors.primary,
                  size: 20.0,
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading catalog...',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        for (int i = 0; i < 4; i++) ...[
          _skeletonCard(),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _skeletonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _skeletonBox(width: 90, height: 18),
              const Spacer(),
              _skeletonBox(width: 70, height: 18),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _skeletonBox(width: 50, height: 50, radius: 8),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonBox(width: 140, height: 16),
                    const SizedBox(height: 6),
                    _skeletonBox(width: 100, height: 13),
                    const SizedBox(height: 6),
                    _skeletonBox(width: 70, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _skeletonBox(width: 80, height: 22),
              _skeletonBox(width: 70, height: 32, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ── Empty States ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Medicines Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CatalogBloc>()
                    .add(const ClearSearchEvent());
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Show All Medicines'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.filter_alt_off_rounded,
              size: 48,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 14),
            const Text(
              'No items match the selected filter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  setState(() => _activeFilter = _CatalogFilter.all),
              child: const Text('Reset Filter to All Items'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State ─────────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to Load Medicines',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CatalogBloc>()
                    .add(const LoadCatalogEvent(forceRefresh: true));
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Interactive Actions ─────────────────────────────────────────────────────

  void _handleAddToCart(BuildContext context, MedicineEntity medicine) {
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
                'Added ${medicine.brandName} to order.',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showMedicineDetails(BuildContext context, MedicineEntity medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            16,
            24,
            MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.brandName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          medicine.saltName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'PKR ${medicine.unitPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 12),
              _detailRow(
                icon: Icons.medication_rounded,
                title: 'Dosage Form & Strength',
                value: '${medicine.dosageForm} • ${medicine.strength}',
              ),
              const SizedBox(height: 10),
              _detailRow(
                icon: Icons.inventory_rounded,
                title: 'Stock Status',
                value: medicine.isInStock
                    ? '${medicine.stockCount} units available'
                    : 'Out of stock',
                valueColor:
                    medicine.isInStock ? AppColors.primary : AppColors.danger,
              ),
              const SizedBox(height: 10),
              _detailRow(
                icon: Icons.receipt_long_rounded,
                title: 'Prescription Policy',
                value: medicine.requiresPrescription
                    ? 'Valid doctor prescription required'
                    : 'Over-the-counter medicine',
                valueColor: medicine.requiresPrescription
                    ? const Color(0xFFB45309)
                    : AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: medicine.isInStock
                      ? () {
                          Navigator.pop(ctx);
                          _handleAddToCart(context, medicine);
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(
                    medicine.isInStock
                        ? 'Add to Order (PKR ${medicine.unitPrice.toStringAsFixed(2)})'
                        : 'Currently Unavailable',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryLight),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
