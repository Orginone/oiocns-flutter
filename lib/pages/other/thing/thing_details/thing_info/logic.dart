import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/pages/other/thing/thing_details/logic.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ThingInfoController extends BaseController<ThingInfoState> {
 final ThingInfoState state = ThingInfoState();


 ThingInfoController();

 var detailsController = Get.find<ThingDetailsController>();

 ThingModel get thing => detailsController.state.thing;

 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    List<Map<ISpeciesItem,Map<String,dynamic>>> currentSpecies = [];
    if(thing.data!=null){
      // CommonTreeManagement().species!.getAllList().forEach((specie) {
      //   for (var data in thing.data!) {
      //     String id = data.keys.first.substring(1);
      //     if(id == specie.id){
      //       currentSpecies.add({specie:data[data.keys.first]});
      //     }
      //   }
      // });
    }
    for (var element in currentSpecies) {
      var data = element[element.keys.first];
      List<CardData> cardData = [];
      for (var attribute in data!.keys) {
        var xAttr = null;
        if(xAttr!=null){
          cardData.add(CardData(xAttr, data[attribute]));
        }
      }
      CardDetails cardDetails = CardDetails(element.keys.first, cardData);
      state.details.add(cardDetails);
    }
    LoadingDialog.dismiss(context);
  }
}
