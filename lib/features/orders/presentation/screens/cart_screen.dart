import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/core/presentation/screens/main_navigation_shell.dart';
import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_bloc.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_event.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_state.dart';
import 'package:med_drop/features/orders/presentation/bloc/order/order_bloc.dart';
import 'package:med_drop/features/orders/presentation/bloc/order/order_event.dart';
import 'package:med_drop/features/orders/presentation/bloc/order/order_state.dart';
import 'package:med_drop/features/orders/presentation/screens/order_success_screen.dart';
import 'package:med_drop/features/prescription/presentation/screens/upload_prescription_screen.dart';
import 'package:med_drop/injection_container.dart';

/// Shopping cart screen with line-item quantity counter controls, prescription
/// requirement checks, price calculations, and checkout submission.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) => sl<OrderBloc>(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatefulWidget {
  const _CartView();

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  String? _selectedPrescriptionId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          // Empty the cart upon confirmed checkout
          context.read<CartBloc>().add(const ClearCartEvent());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(order: state.order),
            ),
          );
        } else if (state is OrderError) {
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
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: [
            BlocBuilder<CartBloc, CartLoaded>(
              builder: (context, state) {
                if (state.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.danger),
                  tooltip: 'Empty Cart',
                  onPressed: () => _confirmClearCart(context),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<CartBloc, CartLoaded>(
            builder: (context, cartState) {
              if (cartState.isEmpty) {
                return _buildEmptyCart(context);
              }

              return Column(
                children: [
                  // ── Prescription Warning Banner if applicable ─────────────
                  if (cartState.containsPrescriptionDrugs)
                    _buildPrescriptionWarningBanner(context),

                  // ── Cart Items List ───────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingHorizontal,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cartState.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cartState.items[index];
                        return _buildCartItemCard(context, item);
                      },
                    ),
                  ),

                  // ── Checkout Bar ──────────────────────────────────────────
                  _buildCheckoutBar(context, cartState),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 46,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse our medicine catalog and add required items to your order.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  MainNavigationShell.switchTab(context, 0);
                }
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Browse Medicines'),
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

  Widget _buildPrescriptionWarningBanner(BuildContext context) {
    final hasAttachedRx = _selectedPrescriptionId != null &&
        _selectedPrescriptionId!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.paddingHorizontal,
        12,
        AppConstants.paddingHorizontal,
        4,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasAttachedRx
            ? AppColors.successLight
            : AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: hasAttachedRx
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasAttachedRx
                    ? Icons.check_circle_rounded
                    : Icons.warning_amber_rounded,
                color: hasAttachedRx
                    ? AppColors.primaryDark
                    : const Color(0xFFB45309),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasAttachedRx
                          ? 'Prescription Attached (#$_selectedPrescriptionId)'
                          : 'Prescription Required',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: hasAttachedRx
                            ? AppColors.primaryDark
                            : const Color(0xFFB45309),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasAttachedRx
                          ? 'Your doctor\'s prescription will be verified during order dispensing.'
                          : 'Your cart contains prescription drugs. Please attach or upload a verified prescription.',
                      style: TextStyle(
                        fontSize: 11,
                        color: hasAttachedRx
                            ? AppColors.textPrimary
                            : const Color(0xFF92400E),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!hasAttachedRx) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToUploadPrescription(context),
                icon: const Icon(Icons.upload_file_rounded, size: 16),
                label: const Text('Upload Prescription Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB45309),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: InkWell(
                onTap: () => _handleAttachOrUploadPrescription(context),
                child: const Text(
                  'Or use a recent approved prescription →',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB45309),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ] else ...[
            InkWell(
              onTap: () => _handleAttachOrUploadPrescription(context),
              child: const Text(
                'Change Prescription →',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItemEntity item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: const Icon(
              Icons.medication_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.medicine.brandName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.medicine.requiresPrescription)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Rx',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.medicine.dosageForm} • ${item.medicine.strength}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PKR ${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Quantity Counter
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    item.quantity == 1
                        ? Icons.delete_outline_rounded
                        : Icons.remove_rounded,
                    size: 16,
                    color: item.quantity == 1
                        ? AppColors.danger
                        : AppColors.textPrimary,
                  ),
                  splashRadius: 16,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: () {
                    context.read<CartBloc>().add(
                          UpdateQuantityEvent(
                            item.medicine.id,
                            item.quantity - 1,
                          ),
                        );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                  splashRadius: 16,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: item.quantity < item.medicine.stockCount
                      ? () {
                          context.read<CartBloc>().add(
                                UpdateQuantityEvent(
                                  item.medicine.id,
                                  item.quantity + 1,
                                ),
                              );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartLoaded cartState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated Subtotal',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'PKR ${cartState.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Standard Delivery',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Free',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total in PKR',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'PKR ${cartState.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Emerald Checkout CTA
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, orderState) {
              final isPlacing = orderState is OrderPlacing;

              return ElevatedButton(
                onPressed: isPlacing ? null : () => _showCheckoutModal(context, cartState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                child: isPlacing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitThreeBounce(color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text('Placing Order...'),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Checkout Dialog & Address ──────────────────────────────────────────────

  void _showCheckoutModal(BuildContext context, CartLoaded cartState) {
    final addressController = TextEditingController(
      text: 'House 14-B, Street 3, F-7/2, Islamabad',
    );
    final rxController = TextEditingController(text: _selectedPrescriptionId ?? '');

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
            MediaQuery.of(ctx).viewInsets.bottom +
                MediaQuery.of(ctx).padding.bottom +
                20,
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
              const SizedBox(height: 16),
              const Text(
                'Complete Your Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Delivery Address Field
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Enter street address, city...',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Prescription Reference Field if Rx required
              if (cartState.containsPrescriptionDrugs) ...[
                const Text(
                  'Prescription Reference (Rx)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: rxController,
                  decoration: InputDecoration(
                    hintText: 'Enter prescription ID (e.g. rx-171829...)',
                    prefixIcon: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFB45309),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Order Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'PKR ${cartState.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final address = addressController.text.trim();
                    if (address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a delivery address.'),
                        ),
                      );
                      return;
                    }

                    final rxId = rxController.text.trim();
                    if (cartState.containsPrescriptionDrugs && rxId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please provide or upload a prescription for Rx medicines.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(ctx);
                    context.read<OrderBloc>().add(
                          PlaceOrderEvent(
                            items: cartState.items,
                            deliveryAddress: address,
                            prescriptionId: rxId.isNotEmpty ? rxId : null,
                          ),
                        );
                  },
                  child: const Text('Confirm & Place Order'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAttachOrUploadPrescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Prescription Requirement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Prescription medicines require verification by our registered pharmacist. You can capture or upload a new prescription, or link an existing reference.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _navigateToUploadPrescription(context);
                },
                icon: const Icon(Icons.add_a_photo_rounded),
                label: const Text('Upload New Prescription'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _selectedPrescriptionId =
                        'rx-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Attached verified prescription #$_selectedPrescriptionId',
                      ),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
                icon: const Icon(Icons.history_rounded),
                label: const Text('Use Recent Approved Prescription'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToUploadPrescription(BuildContext context) async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => const UploadPrescriptionScreen(),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedPrescriptionId = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Prescription #$result linked to your order!'),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Clear Shopping Cart?'),
          content: const Text(
            'All selected medicines will be removed from your current order.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<CartBloc>().add(const ClearCartEvent());
              },
              child: const Text(
                'Clear Cart',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }
}
