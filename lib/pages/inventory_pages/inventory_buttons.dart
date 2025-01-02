import 'package:flutter/material.dart';
import '../pages_structure/button_structure.dart';
import 'add_inventory_popup.dart';

class AddInventoryButton extends GridButton {
  const AddInventoryButton({super.key})
      : super(
            desc: 'Add new\ninventory',
            iconData: Icons.add_box_sharp,
            popUpDialog: const AddInventoryPopup());
}
