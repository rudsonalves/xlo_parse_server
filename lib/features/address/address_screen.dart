// Copyright (C) 2024 Rudson Alves
//
// This file is part of xlo_parse_server.
//
// xlo_parse_server is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_parse_server is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_parse_server.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../new_address/new_address_screen.dart';
import 'address_controller.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  static const routeName = '/address';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final controller = AddressController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  Future<void> _addAddress() async {
    await Navigator.pushNamed(context, NewAddressScreen.routeName);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _removeAddress() async {
    await controller.removeAddress();
    setState(() {});
  }

  void _backPage() {
    Navigator.pop(context, controller.selectedAddressName.value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereços'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _backPage,
        ),
      ),
      floatingActionButton: ButtonBar(
        children: [
          FloatingActionButton(
            onPressed: _addAddress,
            heroTag: 'fab1',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: null, // FIXME: tem de verificar se o endereço está
            // sendo usado em algum anúncio antes de remover.
            // _removeAddress,
            heroTag: 'fab2',
            child: Icon(Icons.remove, color: colorScheme.outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder(
            valueListenable: controller.selectedAddressName,
            builder: (context, seledtedName, _) {
              return ListView.builder(
                itemCount: controller.addressNames.length,
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  return Card(
                    color: address.name == seledtedName
                        ? colorScheme.primaryContainer
                        : colorScheme.primaryContainer.withOpacity(0.4),
                    child: ListTile(
                      title: Text(address.name),
                      subtitle: Text(address.addressString()),
                      onTap: () => controller.selectAddress(address.name),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
