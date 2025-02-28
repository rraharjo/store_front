import 'package:flutter/material.dart';
import 'package:store_front/pages/assets_pages/add_asset.dart';
import 'package:store_front/pages/assets_pages/manage_assets.dart';
import 'asset_list.dart';
import '../pages_structure/button_structure.dart';

class AddAssetButton extends GridButton {
  const AddAssetButton({super.key})
      : super(
            desc: 'Add new\nassets',
            iconData: Icons.add_business,
            nextPage: const AddAsset());
}

class AssetsListButton extends GridButton {
  const AssetsListButton({super.key})
      : super(
            desc: 'Assets\nlist',
            iconData: Icons.warehouse_outlined,
            nextPage: const AssetsList());
}

class ManageAssetsButton extends GridButton {
  const ManageAssetsButton({super.key})
      : super(
      desc: 'Manage\nassets',
      iconData: Icons.bar_chart_outlined,
      nextPage: const ManageAssets());
}
