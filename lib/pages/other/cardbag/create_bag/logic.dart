import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/other/cardbag/create_bag/backup_mnemonics.dart';

import 'create_wallet.dart';
import 'state.dart';
import 'tips.dart';
import 'verify_mnemonic.dart';

class CreateBagController extends BaseController<CreateBagState> {
  final CreateBagState state = CreateBagState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.pages.add(Tips());
    state.pages.add(BackupMnemonics());
    state.pages.add(VerifyMnemonic());
    state.pages.add(CreateWallet());
  }

  void setMnemonics(List<String> mnemonics){
    state.mnemonics = mnemonics;
  }

  void nextPage(){
    state.currentStep.value++;
    state.pageController.jumpToPage(state.currentStep.value);
  }

  void jumpPage(int index){
    state.currentStep.value = index;
    state.pageController.jumpToPage(state.currentStep.value);
  }

  @override
  void onClose() {
    state.pageController.dispose();
    super.onClose();
  }
}
