import '../pages_structure/page_structure.dart';
import '../pages_structure/button_structure.dart';

class AssetsGrid extends MainGrid {
  AssetsGrid({super.key});

  @override
  void addButtons() {
    buttons.add(SampleButton());
    buttons.add(SampleButton());
    buttons.add(SampleButton());
    buttons.add(SampleButton());
  }
}