import 'package:store_front/pages/assets_pages/asset_buttons.dart';

import '../pages_structure/page_structure.dart';

class AssetsGrid extends MainGrid {
  AssetsGrid({super.key});

  @override
  void addButtons() {
    buttons.add(AddAssetButton());
    buttons.add(AssetsListButton());
    buttons.add(ManageAssetsButton());
  }
}