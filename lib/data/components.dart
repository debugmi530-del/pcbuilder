import '../models/component.dart';
import 'cpu_components.dart';
import 'gpu_components.dart';
import 'ram_components.dart';
import 'storage_components.dart';
import 'psu_components.dart';
import 'motherboard_components.dart';
import 'case_components.dart';
import 'cooling_components.dart';

final List<Component> allComponents = [
  ...cpuComponents,
  ...gpuComponents,
  ...ramComponents,
  ...storageComponents,
  ...psuComponents,
  ...motherboardComponents,
  ...caseComponents,
  ...coolingComponents,
];

// Fast lookup by id
Component? findComponentById(String id) {
  try {
    return allComponents.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

// Grouped by category
Map<ComponentCategory, List<Component>> get componentsByCategory {
  final map = <ComponentCategory, List<Component>>{};
  for (final c in allComponents) {
    map.putIfAbsent(c.category, () => []).add(c);
  }
  return map;
}

List<Component> getByCategory(ComponentCategory cat) =>
    allComponents.where((c) => c.category == cat).toList();
