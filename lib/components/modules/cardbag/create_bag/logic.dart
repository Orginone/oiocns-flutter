import 'package:orginone/components/modules/cardbag/index.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

class CreateBagController extends BaseController<CreateBagState> {
  @override
  final CreateBagState state = CreateBagState();

  @override
  void onInit() {
    super.onInit();
    state.pages.add(const Tips());
    state.pages.add(const BackupMnemonics());
    state.pages.add(const VerifyMnemonic());
    state.pages.add(const CreateWallet());
  }

  void setMnemonics(List<String> mnemonics, int type) {
    state.mnemonics = mnemonics;
    state.mnemonicType = type;
  }

  void nextPage() {
    state.currentStep.value++;
    state.pageController.jumpToPage(state.currentStep.value);
  }

  void jumpPage(int index) {
    state.currentStep.value = index;
    state.pageController.jumpToPage(state.currentStep.value);
  }

  @override
  void onClose() {
    state.pageController.dispose();
    super.onClose();
  }
}
