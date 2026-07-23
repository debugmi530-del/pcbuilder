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

  static const String _brandKey = 'Бренд';

  List<String> _uniqueValues(List<Component> components, String key) {
    if (key == _brandKey) {
      return components.map((c) => c.brand).toSet().toList()..sort();
    }
    return components
        .map((c) => c.specs[key])
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
  }

  List<String> _filterKeys() {
    switch (widget.category) {
      case ComponentCategory.cpu:
        return [
          _brandKey,
          'Сокет',
          'Ядра (всего)',
          'Техпроцесс',
          'Тип памяти',
          'Базовое тепловыделение (TDP)',
          'Встроенная графика',
          'Свободный множитель',
          'Поддержка ECC-памяти',
          'Встроенный контроллер PCIe',
          'Система охлаждения в комплекте',
        ];
      case ComponentCategory.gpu:
        return [
          _brandKey,
          'Видеопамять',
          'Интерфейс',
          'TDP',
          'Архитектура (микроархитектура)',
          'Разрядность шины памяти',
          'Количество занимаемых слотов',
          'Тип охлаждения',
          'Подсветка',
          'Версия HDMI',
          'Версия DisplayPort',
        ];
      case ComponentCategory.ram:
        return [
          _brandKey,
          'Тип',
          'Объём',
          'Частота',
          'Тип модуля',
          'Intel XMP',
          'AMD EXPO',
          'ECC',
          'Подсветка',
          'Радиатор',
          'Низкопрофильная',
        ];
      case ComponentCategory.storage:
        return [
          _brandKey,
          'Форм-фактор',
          'Интерфейс',
          'Ёмкость',
          'NVMe',
          'Технология',
          'Назначение',
          'DRAM буфер',
          'Шифрование',
          'Гарантия',
        ];
      case ComponentCategory.psu:
        return [
          _brandKey,
          'Мощность',
          'Сертификат',
          'Модульность',
          'Форм-фактор',
          'PFC',
          'PCIe 5.0',
          'Режим Fanless',
          'Вентилятор',
          'Оплётка проводов',
        ];
      case ComponentCategory.motherboard:
        return [
          _brandKey,
          'Сокет',
          'Чипсет',
          'Форм-фактор',
          'Тип памяти',
          'Версия PCIe (основной слот)',
          'Слоты M.2',
          'Wi-Fi',
          'Bluetooth',
          'Подсветка',
          'Звуковая схема',
        ];
      case ComponentCategory.pcCase:
        return [
          _brandKey,
          'Типоразмер',
          'Форм-факторы плат',
          'Материал окна',
          'Цвет',
          'Тип подсветки',
          'Пылевые фильтры',
          'Кардридер',
          'Звукоизоляция',
        ];
      case ComponentCategory.cooling:
        return [
          _brandKey,
          'Тип конструкции',
          'TDP',
          'Сокеты AMD',
          'Сокеты Intel',
          'Тип подсветки',
          'Управление',
          'LCD дисплей',
          'Термопаста в комплекте',
        ];
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

    if (_selectedSectionIndex >= filterKeys.length) {
      _selectedSectionIndex = 0;
    }

    final currentKey = filterKeys[_selectedSectionIndex];
    final currentValues = _uniqueValues(components, currentKey);
    final activeSet = provider.activeFilters[currentKey] ?? {};
    final totalActive = _totalActiveCount(provider.activeFilters);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Фильтры',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          if (provider.activeFilters.isNotEmpty)
            TextButton(
              onPressed: () =>
                  provider.clearFiltersForCategory(widget.category.key),
              child: const Text(
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
          child: Container(height: 1, color: AppTheme.divider),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: Section list ──
          Container(
            width: 150,
            color: const Color(0xFFF0F1F3),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filterKeys.length,
              itemBuilder: (context, index) {
                final key = filterKeys[index];
                final isSelected = index == _selectedSectionIndex;
                final sectionHasActive =
                    provider.activeFilters[key]?.isNotEmpty ?? false;

                return GestureDetector(
                  onTap: () => setState(() => _selectedSectionIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: isSelected
                          ? Border(
                              left: BorderSide(
                                color: AppTheme.primary,
                                width: 3,
                              ),
                            )
                          : const Border(
                              left: BorderSide(
                                color: Colors.transparent,
                                width: 3,
                              ),
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
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
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        if (sectionHasActive)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
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
          Container(width: 1, color: AppTheme.divider),

          // ── Right: Values for selected section ──
          Expanded(
            child: currentValues.isEmpty
                ? const Center(
                    child: Text(
                      'Нет вариантов',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
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
                        onTap: () =>
                            provider.toggleFilter(currentKey, value),
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
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
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
                                    color: AppTheme.textPrimary,
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
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppTheme.divider, width: 1),
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
