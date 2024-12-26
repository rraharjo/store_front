import '../pages_structure/page_structure.dart';
import '../pages_structure/button_structure.dart';

class InventoryGrid extends MainGrid {
  InventoryGrid({super.key});

  @override
  void addButtons() {
    buttons.add(SampleButton());
    buttons.add(SampleButton());
  }
}