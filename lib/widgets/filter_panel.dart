import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/component.dart';
import '../data/components.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

class FilterScreen extends StatefulWidget {
  final ComponentCategory category;
  const FilterScreen({super.key, required this.category});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _selectedSectionIndex = 0;

  // Get unique values for a spec key across all components in this category
  List<String> _uniqueValues(List<Component> components, String key) {
    return components
        .map((c) => c.specs[key])
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
  }

  // Get relevant filter keys per category
  List<String> _filterKeys() {
    switch (widget.category) {
      case ComponentCategory.cpu:
        return ['Сокет', 'Техпроцесс', 'TDP'];
      case ComponentCategory.gpu:
        return ['Видеопамять', 'Интерфейс', 'TDP'];
      case ComponentCategory.ram:
        return ['Тип', 'Объём', 'Частота'];
      case ComponentCategory.storage:
        return ['Форм-фактор', 'Интерфейс', 'Ёмкость'];
      case ComponentCategory.psu:
        return ['Мощность', 'Сертификат', 'Модульность'];
      case ComponentCategory.motherboard:
        return ['Сокет', 'Чипсет', 'Форм-фактор'];
      case ComponentCategory.pcCase:
        return ['Тип', 'Материнские платы'];
      case ComponentCategory.cooling:
        return ['Тип', 'TDP'];
    }
  }

  int _totalActiveCount(Map<String, Set<String>> activeFilters) {
    return activeFilters.values.fold<int>(0, (s, v) => s + v.length);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final components = getByCategory(widget.category);
    final filterKeys = _filterKeys();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Clamp selected index in case keys changed
    if (_selectedSectionIndex >= filterKeys.length) {
      _selectedSectionIndex = 0;
    }

    final currentKey = filterKeys[_selectedSectionIndex];
    final currentValues = _uniqueValues(components, currentKey);
    final activeSet = provider.activeFilters[currentKey] ?? {};
    final totalActive = _totalActiveCount(provider.activeFilters);

    final Color leftBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F1F3);
    final Color rightBg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color sectionActiveBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final Color sectionActiveBorder = AppTheme.primary;
    final Color sectionTextActive = isDark ? Colors.white : AppTheme.textPrimary;
    final Color sectionTextInactive = isDark ? const Color(0xFF9CA3AF) : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: rightBg,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Фильтры',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          if (provider.activeFilters.isNotEmpty)
            TextButton(
              onPressed: () =>
                  provider.clearFiltersForCategory(widget.category.key),
              child: Text(
                'Сбросить всё',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF2A2A2A) : AppTheme.divider,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: Section list ──
          Container(
            width: 150,
            color: leftBg,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filterKeys.length,
              itemBuilder: (context, index) {
                final key = filterKeys[index];
                final isSelected = index == _selectedSectionIndex;
                final sectionActive = provider.activeFilters[key]?.isNotEmpty ?? false;

                return GestureDetector(
                  onTap: () => setState(() => _selectedSectionIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected ? sectionActiveBg : Colors.transparent,
                      border: isSelected
                          ? Border(
                              left: BorderSide(
                                color: sectionActiveBorder,
                                width: 3,
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            key,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? sectionTextActive
                                  : sectionTextInactive,
                            ),
                          ),
                        ),
                        if (sectionActive)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Vertical divider
          Container(
            width: 1,
            color: isDark ? const Color(0xFF2A2A2A) : AppTheme.divider,
          ),

          // ── Right: Values for selected section ──
          Expanded(
            child: currentValues.isEmpty
                ? Center(
                    child: Text(
                      'Нет вариантов',
                      style: TextStyle(
                        color: sectionTextInactive,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: currentValues.length,
                    itemBuilder: (context, index) {
                      final value = currentValues[index];
                      final isChecked = activeSet.contains(value);

                      return InkWell(
                        onTap: () => provider.toggleFilter(currentKey, value),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (_) =>
                                    provider.toggleFilter(currentKey, value),
                                activeColor: AppTheme.primary,
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF6B7280)
                                      : const Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isChecked
                                        ? (isDark ? Colors.white : AppTheme.textPrimary)
                                        : (isDark
                                            ? const Color(0xFFD1D5DB)
                                            : AppTheme.textPrimary),
                                    fontWeight: isChecked
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ── Bottom: Apply button ──
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: rightBg,
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF2A2A2A) : AppTheme.divider,
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                totalActive == 0
                    ? 'Показать результаты'
                    : 'Показать результаты ($totalActive)',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
