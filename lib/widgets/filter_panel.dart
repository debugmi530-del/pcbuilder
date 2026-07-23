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
          // Архитектура
          'Сокет',
          'Техпроцесс',
          'Кодовое название ядра',
          'Год релиза',
          // Ядра и потоки
          'Ядра (всего)',
          'Потоки',
          // Частоты
          'Максимальная частота (P-core)',
          'Максимальная частота',
          // Кэш
          'Кэш L3',
          // Память
          'Тип памяти',
          // Тепловыделение
          'Базовое тепловыделение (TDP)',
          'Максимальное тепловыделение (MTP)',
          'Максимальное тепловыделение (PPT)',
          // Графика и расширения
          'Встроенная графика',
          'Встроенный контроллер PCIe',
          // Функции
          'Свободный множитель',
          'Поддержка ECC-памяти',
          'NPU (нейронный процессор)',
          'Технология виртуализации',
          'Система охлаждения в комплекте',
        ];

      case ComponentCategory.gpu:
        return [
          _brandKey,
          // Архитектура
          'Архитектура (микроархитектура)',
          'Техпроцесс',
          // Память
          'Видеопамять',
          'Разрядность шины памяти',
          // Интерфейс
          'Интерфейс',
          'Разъём питания',
          // Производительность
          'TDP',
          // Выходы
          'Версия HDMI',
          'Версия DisplayPort',
          'Количество мониторов',
          // Конструктив
          'Тип охлаждения',
          'Количество вентиляторов',
          'Количество занимаемых слотов',
          // Особенности
          'Подсветка',
          'Переключатель BIOS',
          'Предназначена для майнинга',
        ];

      case ComponentCategory.ram:
        return [
          _brandKey,
          // Тип и конфигурация
          'Тип',
          'Тип модуля',
          'Объём',
          'Количество модулей',
          'Объём одного модуля',
          // Производительность
          'Частота',
          'Тайминги',
          'Напряжение',
          // Поддержка разгона
          'Intel XMP',
          'AMD EXPO',
          // Надёжность
          'ECC',
          'Регистровая',
          // Конструктив
          'Радиатор',
          'Цвет радиатора',
          'Подсветка',
          'Низкопрофильная',
          // Гарантия
          'Гарантия',
        ];

      case ComponentCategory.storage:
        return [
          _brandKey,
          // Тип и интерфейс
          'Форм-фактор',
          'Интерфейс',
          'NVMe',
          // Объём
          'Ёмкость',
          // Технология
          'Структура памяти',
          'DRAM буфер',
          'Технология',
          // Для HDD
          'Скорость вращения шпинделя',
          'Оптимизация под RAID',
          // Назначение и защита
          'Назначение',
          'Шифрование',
          // Ресурс
          'Гарантия',
        ];

      case ComponentCategory.psu:
        return [
          _brandKey,
          // Мощность и сертификат
          'Мощность',
          'Сертификат',
          'Соответствие стандарту',
          // Кабели
          'Модульность',
          'Оплётка проводов',
          // Разъёмы
          'PCIe 5.0',
          // Конструктив
          'Форм-фактор',
          'Вентилятор',
          // Функции
          'PFC',
          'Режим Fanless',
          'Дисплей',
          // Надёжность
          'Конденсаторы',
          'Гарантия',
        ];

      case ComponentCategory.motherboard:
        return [
          _brandKey,
          // Совместимость
          'Сокет',
          'Чипсет',
          'Форм-фактор',
          // Память
          'Тип памяти',
          'Слоты памяти',
          'Максимальный объём памяти',
          'Каналы памяти',
          // Расширение
          'Версия PCIe (основной слот)',
          'Слоты PCIe x16',
          'Слоты M.2',
          'Количество портов SATA',
          // Беспроводные модули
          'Wi-Fi',
          'Bluetooth',
          // Сеть и звук
          'Сетевой адаптер',
          'Звуковая схема',
          // Внешний вид
          'Подсветка',
        ];

      case ComponentCategory.pcCase:
        return [
          _brandKey,
          // Размер и совместимость
          'Типоразмер',
          'Форм-факторы плат',
          // Материалы и внешний вид
          'Материал корпуса',
          'Материал окна',
          'Цвет',
          'Тип подсветки',
          // Слоты и отсеки
          'Горизонт. слоты расширения',
          'Верт. слоты расширения',
          'Отсеки 2.5"',
          'Отсеки 3.5"',
          // Передняя панель
          'USB Type-C (передняя панель)',
          'Кардридер',
          // Удобство сборки
          'Пылевые фильтры',
          'Звукоизоляция',
        ];

      case ComponentCategory.cooling:
        return [
          _brandKey,
          // Тип
          'Тип конструкции',
          // Для СЖО
          'Монтажный размер радиатора',
          // Производительность
          'TDP',
          'Уровень шума',
          // Совместимость
          'Сокеты Intel',
          'Сокеты AMD',
          // Конструктив
          'Тип подшипника',
          'VRM-вентилятор',
          'Никелированное покрытие',
          // Особенности
          'Тип подсветки',
          'LCD дисплей',
          'Управление',
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
        hint = 'Проверяет поддержку сокета CPU, высоту кулера относительно корпуса и размер радиатора СЖО относительно посадочных мест корпуса';
        break;
      case ComponentCategory.pcCase:
        hint = 'Проверяет поддерживаемый форм-фактор материнской платы';
        break;
      case ComponentCategory.psu:
        hint =
            'Показывает БП с достаточной мощностью для процессора и видеокарты (×1.3 запас). Также проверяет длину БП относительно корпуса';
        break;
      case ComponentCategory.gpu:
        hint = 'Проверяет длину видеокарты относительно максимальной длины в корпусе';
        break;
      case ComponentCategory.storage:
        hint = 'Скрывает накопители, если все слоты корпуса уже заняты';
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
