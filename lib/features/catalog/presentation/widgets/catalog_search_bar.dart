import 'dart:async';
import 'package:flutter/material.dart';

import 'package:med_drop/core/constants/app_colors.dart';
import 'package:med_drop/core/constants/app_constants.dart';

/// Debounced search bar input field featuring a clear button and filter action.
class CatalogSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final String hintText;
  final Duration debounceDuration;

  const CatalogSearchBar({
    super.key,
    required this.onSearch,
    this.onClear,
    this.onFilterTap,
    this.hintText = 'Search by brand or active ingredient (salt)...',
    this.debounceDuration = AppConstants.searchDebounce,
  });

  @override
  State<CatalogSearchBar> createState() => _CatalogSearchBarState();
}

class _CatalogSearchBarState extends State<CatalogSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final text = _controller.text;
    final hasText = text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearch(text);
    });
  }

  void _handleClear() {
    _debounceTimer?.cancel();
    _controller.clear();
    widget.onClear?.call();
    widget.onSearch('');
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          _debounceTimer?.cancel();
          widget.onSearch(query);
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.surface,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textDisabled,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasText)
                IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: AppColors.textDisabled,
                  ),
                  splashRadius: 18,
                  onPressed: _handleClear,
                  tooltip: 'Clear search',
                ),
              if (widget.onFilterTap != null) ...[
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.divider,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: AppColors.secondaryLight,
                  ),
                  splashRadius: 20,
                  onPressed: widget.onFilterTap,
                  tooltip: 'Filter medicines',
                ),
              ],
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
