import 'package:flutter/material.dart';

class PCProvider extends ChangeNotifier {
  // Selected PC Parts and their images
  String? selectedCPU;
  String? cpuImage;
  
  String? selectedGPU;
  String? gpuImage;
  
  String? selectedMotherboard;
  String? motherboardImage;
  
  String? selectedRAM;
  String? ramImage;
  
  String? selectedStorage;
  String? storageImage;
  
  String? selectedPowerSupply;
  String? psuImage;
  
  String? selectedCase;
  String? caseImage;


  //my addings
  String? socketType;
  String? ramType;

  // Update methods for each component
  void updateCPU(String cpu, String image, String sockettype) {
    selectedCPU = cpu;
    cpuImage = image;
    socketType = sockettype;
    notifyListeners();
  }

  void updateGPU(String gpu, String image) {
    selectedGPU = gpu;
    gpuImage = image;
    notifyListeners();
  }

  void updateMotherboard(String motherboard, String image, String ramtype) {
    selectedMotherboard = motherboard;
    motherboardImage = image;
    ramType = ramtype;
    notifyListeners();
  }

  void updateRAM(String ram, String image) {
    selectedRAM = ram;
    ramImage = image;
    notifyListeners();
  }

  void updateStorage(String storage, String image) {
    selectedStorage = storage;
    storageImage = image;
    notifyListeners();
  }

  void updatePowerSupply(String psu, String image) {
    selectedPowerSupply = psu;
    psuImage = image;
    notifyListeners();
  }

  void updateCase(String pcCase, String image) {
    selectedCase = pcCase;
    caseImage = image;
    notifyListeners();
  }
  
  // Reset Storage
  void resetStorage() {

    selectedStorage = null;
    storageImage = null;

    notifyListeners();
  }

  // Reset Processor
  void resetCPU() {

    selectedCPU = null;
    cpuImage = null;

    notifyListeners();
  }

  // Reset Ram
  void resetRam() {

    selectedRAM = null;
    ramImage = null;

    notifyListeners();
  }

  // Reset Psu
  void resetPsu() {

    selectedPowerSupply = null;
    psuImage = null;

    notifyListeners();
  }

  // Reset Storage
  void resetMotherboard() {

    selectedMotherboard = null;
    motherboardImage = null;

    notifyListeners();
  }


   // Reset TDP
  void resetTDP() {

    selectedStorage = null;
    storageImage = null;

    notifyListeners();
  } 

  // Reset all selections
  void resetSelections() {
    selectedCPU = null;
    cpuImage = null;
    
    selectedGPU = null;
    gpuImage = null;
    
    selectedMotherboard = null;
    motherboardImage = null;
    
    selectedRAM = null;
    ramImage = null;
    
    selectedStorage = null;
    storageImage = null;
    
    selectedPowerSupply = null;
    psuImage = null;
    
    selectedCase = null;
    caseImage = null;
    
    notifyListeners();
  }
}