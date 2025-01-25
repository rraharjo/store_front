import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/button_structure.dart';
import 'add_inventory_popup.dart';
import 'list_inventory_popup.dart';
import 'purchase_inventory.dart';

class AddInventoryButton extends GridButton {
  const AddInventoryButton({super.key})
      : super(
      desc: 'Add new\ninventory',
      iconData: Icons.add_box_sharp,
      nextPage: const AddInventory());
}

class ListInventoryButton extends GridButton {
  const ListInventoryButton({super.key})
      : super(
      desc: 'Inventory\nList',
      iconData: Icons.inventory_2_outlined,
      nextPage: const InventoriesList());
}

class PurchaseInventoryButton extends GridButton {
  const PurchaseInventoryButton({super.key}) : super(
    desc: 'Purchase\nInventories',
    iconData: Icons.monetization_on_outlined,
    nextPage: const PurchaseInventories(),);
}