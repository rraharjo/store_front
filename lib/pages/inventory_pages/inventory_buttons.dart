import 'package:flutter/material.dart';
import '../pages_structure/pop_up_dialog.dart';
import '../pages_structure/button_structure.dart';
import 'inventory_pop_up.dart';

class AddInventoryButton extends GridButton {
  const AddInventoryButton({super.key})
      : super(
            desc: 'Add new\ninventory',
            iconData: Icons.add_box_sharp,
            popUpDialog: const AddInventoryPopup());
}
