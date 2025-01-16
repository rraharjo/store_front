import 'package:flutter/material.dart';
import '../pages_structure/button_structure.dart';
import 'add_inventory_popup.dart';
import 'list_inventory_popup.dart';
import 'purchase_inventory.dart';

class AddInventoryButton extends GridButton {
  const AddInventoryButton({super.key})
      : super(
      desc: 'Add new\ninventory',
      iconData: Icons.add_box_sharp,
      popUpDialog: const AddInventoryPopup());
}

class ListInventoryButton extends GridButton {
  const ListInventoryButton({super.key})
      : super(
      desc: 'Inventory\nList',
      iconData: Icons.inventory_2_outlined,
      popUpDialog: const InventoryList());
}

class PurchaseInventoryButton extends GridButton {
  const PurchaseInventoryButton({super.key}) : super(
    desc: 'Purchase\nInventories',
    iconData: Icons.monetization_on_outlined,
    popUpDialog: const PurchaseInventoryPopup(),);
}