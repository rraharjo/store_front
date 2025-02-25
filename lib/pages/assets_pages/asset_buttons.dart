import 'package:flutter/material.dart';
import 'package:store_front/pages/assets_pages/add_asset.dart';
import '../pages_structure/button_structure.dart';

class AddAssetButton extends GridButton {
  const AddAssetButton({super.key})
      : super(
      desc: 'Add new\ninventory',
      iconData: Icons.add_business,
      nextPage: const AddAsset());
}