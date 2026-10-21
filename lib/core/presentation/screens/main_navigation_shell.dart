import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_bloc.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_state.dart';
import 'package:med_drop/features/orders/presentation/screens/cart_screen.dart';
import 'package:med_drop/features/orders/presentation/screens/order_history_screen.dart';
import 'package:med_drop/features/prescription/presentation/screens/upload_prescription_screen.dart';

/// Top-level shell providing seamless bottom navigation between Catalog,
/// Prescription Upload, Shopping Cart, and Orders History.
class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
  });

  /// Allows any descendant widget to request a tab switch.
  /// Returns true if a shell was found and the tab switched, false otherwise.
  static bool switchTab(BuildContext context, int tabIndex) {
    final state =
        context.findAncestorStateOfType<_MainNavigationShellState>();
    if (state != null) {
      state.setTabIndex(tabIndex);
      return true;
    }
    return false;
  }

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  static const List<Widget> _tabs = [
    CatalogScreen(),
    UploadPrescriptionScreen(),
    CartScreen(),
    OrderHistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void setTabIndex(int index) {
    if (index >= 0 && index < _tabs.length && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: setTabIndex,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.14),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon:
                  Icon(Icons.medication_rounded, color: AppColors.primary),
              label: 'Catalog',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon:
                  Icon(Icons.receipt_long_rounded, color: AppColors.primary),
              label: 'Prescription',
            ),
            NavigationDestination(
              icon: _buildCartBadge(isSelected: false),
              selectedIcon: _buildCartBadge(isSelected: true),
              label: 'My Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon:
                  Icon(Icons.local_shipping_rounded, color: AppColors.primary),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBadge({required bool isSelected}) {
    return BlocBuilder<CartBloc, CartLoaded>(
      builder: (context, state) {
        final count = state.totalItemUnits;

        return Badge(
          isLabelVisible: count > 0,
          label: Text(
            '$count',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.danger,
          child: Icon(
            isSelected
                ? Icons.shopping_cart_rounded
                : Icons.shopping_cart_outlined,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        );
      },
    );
  }
}
