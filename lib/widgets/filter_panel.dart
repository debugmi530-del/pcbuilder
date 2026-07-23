import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/component.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

// Специальный ключ для секции совместимости (не спек-фильтр)
const String _kCompatKey = '__compat__';

class FilterScreen extends StatefulWidget {
  final ComponentCategory category;
  const FilterScreen({super.key, required this.category});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _selectedSectionIndex = 0;

  static const String _brandKey = 'Бренд';

  List<String> _specFilterKeys() {
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

  /// Все секции: "Совместимые" всегда первой
  List<String> _allKeys() => [_kCompatKey, ..._specFilterKeys()];

  /// Человекочитаемое имя секции для левой панели
  String _sectionLabel(String key) {
    if (key == _kCompatKey) return 'Совместимые';
    return key;
  }

  /// Подсчитывает, сколько компонентов соответствует каждому значению
  /// фильтра [key], при уже применённых остальных активных фильтрах.
  Map<String, int> _computeCounts(
    AppProvider provider,
    String key,
  ) {
    // Базовый список: с совместимостью + все активные фильтры, кроме текущего ключа
    final base = provider.rawFilteredForCategory(
      widget.category,
      excludeFilterKey: key,
    );

    final counts = <String, int>{};
    for (final c in base) {
      final String? val =
          key == _brandKey ? c.brand : c.specs[key];
      if (val != null) {
        counts[val] = (counts[val] ?? 0) + 1;
      }
    }
    return counts;
  }

  int _totalActiveCount(Map<String, Set<String>> activeFilters) {
    return activeFilters.values.fold<int>(0, (s, v) => s + v.length);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final allKeys = _allKeys();

    if (_selectedSectionIndex >= allKeys.length) {
      _selectedSectionIndex = 0;
    }

    final currentKey = allKeys[_selectedSectionIndex];
    final activeSet = provider.activeFilters[currentKey] ?? {};
    final totalActive = _totalActiveCount(provider.activeFilters) +
        (provider.compatibilityFilterEnabled ? 1 : 0);
    final hasBuild = provider.hasBuildForCompatibility;

    // Для совместимости — отдельный счётчик
    final compatCount = hasBuild ? provider.compatibleCount(widget.category) : null;

    // Для спек-секций — считаем значения с кол-вом
    final valueCounts = currentKey != _kCompatKey
        ? _computeCounts(provider, currentKey)
        : <String, int>{};

    // Только значения с count > 0, отсортированные
    final currentValues = currentKey != _kCompatKey
        ? (valueCounts.keys.where((v) => valueCounts[v]! > 0).toList()
          ..sort(_naturalSort))
        : <String>[];

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
          if (totalActive > 0)
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
              itemCount: allKeys.length,
              itemBuilder: (context, index) {
                final key = allKeys[index];
                final isSelected = index == _selectedSectionIndex;
                final isCompat = key == _kCompatKey;

                final sectionHasActive = isCompat
                    ? provider.compatibilityFilterEnabled
                    : (provider.activeFilters[key]?.isNotEmpty ?? false);

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedSectionIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? AppTheme.primary
                              : Colors.transparent,
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
                            _sectionLabel(key),
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

          // ── Right: Values ──
          Expanded(
            child: currentKey == _kCompatKey
                ? _buildCompatSection(
                    provider, hasBuild, compatCount)
                : currentValues.isEmpty
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
                        padding:
                            const EdgeInsets.only(top: 4, bottom: 16),
                        itemCount: currentValues.length,
                        itemBuilder: (context, index) {
                          final value = currentValues[index];
                          final count = valueCounts[value] ?? 0;
                          final isChecked = activeSet.contains(value);

                          return InkWell(
                            onTap: () => provider.toggleFilter(
                                currentKey, value),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (_) => provider
                                        .toggleFilter(currentKey, value),
                                    activeColor: AppTheme.primary,
                                    side: const BorderSide(
                                      color: Color(0xFFD1D5DB),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4),
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
                                  const SizedBox(width: 4),
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
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

  /// Секция "Совместимые" в правой панели
  Widget _buildCompatSection(
    AppProvider provider,
    bool hasBuild,
    int? compatCount,
  ) {
    final isEnabled = provider.compatibilityFilterEnabled;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Toggle — "Только совместимые"
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasBuild ? provider.toggleCompatibilityFilter : null,
          child: Container(
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.chip
                  : const Color(0xFFF9FAFB),
              border: Border.all(
                color: isEnabled
                    ? AppTheme.primary
                    : AppTheme.divider,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isEnabled
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: isEnabled
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Только совместимые',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isEnabled
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isEnabled
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                      if (compatCount != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '$compatCount товаров',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: hasBuild
                      ? (_) => provider.toggleCompatibilityFilter()
                      : null,
                  activeColor: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Подсказка если сборка пустая
        if (!hasBuild)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFFFFD700), width: 1),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline,
                    size: 18, color: Color(0xFF856404)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Добавьте комплектующие в сборку, чтобы включить фильтр совместимости',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF856404),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Пояснение что проверяется
        if (hasBuild) ...[
          const SizedBox(height: 8),
          _buildCompatHint(widget.category),
        ],
      ],
    );
  }

  /// Подсказка что именно проверяет фильтр для данной категории
  Widget _buildCompatHint(ComponentCategory category) {
    final String hint;
    switch (category) {
      case ComponentCategory.cpu:
        hint =
            'Проверяет совместимость сокета с материнской платой и тип памяти с ОЗУ';
        break;
      case ComponentCategory.motherboard:
        hint =
            'Проверяет сокет с процессором, тип памяти с ОЗУ и форм-фактор с корпусом';
        break;
      case ComponentCategory.ram:
        hint =
            'Проверяет тип памяти (DDR4/DDR5) с материнской платой и процессором';
        break;
      case ComponentCategory.cooling:
        hint = 'Проверяет поддержку сокета процессора';
        break;
      case ComponentCategory.pcCase:
        hint = 'Проверяет поддерживаемый форм-фактор материнской платы';
        break;
      case ComponentCategory.psu:
        hint =
            'Показывает БП с достаточной мощностью для процессора и видеокарты (×1.3 запас)';
        break;
      default:
        hint = 'Фильтр по совместимости не применяется для этой категории';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline,
            size: 14, color: AppTheme.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Натуральная сортировка строк (числа сортируются как числа).
int _naturalSort(String a, String b) {
  final re = RegExp(r'(\d+|\D+)');
  final partsA = re.allMatches(a).map((m) => m.group(0)!).toList();
  final partsB = re.allMatches(b).map((m) => m.group(0)!).toList();
  for (int i = 0; i < partsA.length && i < partsB.length; i++) {
    final na = int.tryParse(partsA[i]);
    final nb = int.tryParse(partsB[i]);
    final int cmp;
    if (na != null && nb != null) {
      cmp = na.compareTo(nb);
    } else {
      cmp = partsA[i].compareTo(partsB[i]);
    }
    if (cmp != 0) return cmp;
  }
  return partsA.length.compareTo(partsB.length);
}
