import 'package:flutter/material.dart';
import 'package:manual_build/psu.dart';
import 'package:provider/provider.dart';
import 'pc_provider.dart';
import 'harddisk.dart';
import 'processor.dart';
import 'ram.dart';
import 'motherboard.dart';

class PCSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Build Your PC")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSelectionItem(
                  context,
                  "Select CPU",
                  context.watch<PCProvider>().selectedCPU,
                  context.watch<PCProvider>().cpuImage,
                                    () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProcessorListScreen()),
                    );
                  },
                  context.read<PCProvider>().resetCPU,
                ),
                buildSelectionItem(
                  context,
                  "Select Motherboard",
                  context.watch<PCProvider>().selectedMotherboard,
                  context.watch<PCProvider>().motherboardImage,
                                    () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MotherboardListScreen()),
                    );
                  },
                  context.read<PCProvider>().resetMotherboard,
                ),
                buildSelectionItem(
                  context,
                  "Select RAM",
                  context.watch<PCProvider>().selectedRAM,
                  context.watch<PCProvider>().ramImage,
                                    () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RAMListScreen()),
                    );
                  },
                  context.read<PCProvider>().resetRam,
                ),
                buildSelectionItem(
                  context,
                  "Select Storage",
                  context.watch<PCProvider>().selectedStorage,
                  context.watch<PCProvider>().storageImage,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HardDiskListScreen()),
                    );
                  },
                  context.read<PCProvider>().resetStorage,
                ),
                buildSelectionItem(
                  context,
                  "Select Power Supply",
                  context.watch<PCProvider>().selectedPowerSupply,
                  context.watch<PCProvider>().psuImage,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PSUListScreen()),
                    );
                  },
                  context.read<PCProvider>().resetPsu,
                ),
                SizedBox(height: 20), // Prevents clipping at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectionItem(
  BuildContext context,
  String title,
  String? selectedItem,
  String? imageUrl,
  VoidCallback onSelect, // Add this parameter
  VoidCallback onRemove,
) {
  return Column(
    children: [
      GestureDetector(  // Enable tapping
        onTap: onSelect, // Call the onSelect function
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: selectedItem == null
                ? Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imageUrl != null)
                        Image.network(imageUrl, width: 50, height: 50),
                      SizedBox(width: 10),
                      Text(
                        selectedItem,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      SizedBox(height: 10),
      if (selectedItem != null)
        ElevatedButton(
          onPressed: onRemove,
          child: Text("Remove"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      SizedBox(height: 10),
    ],
  );
}

}
