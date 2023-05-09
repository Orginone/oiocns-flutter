
import 'package:orginone/dart/core/thing/base/form.dart';

abstract class IWorkForm extends IForm {}


 class WorkForm extends Form implements IWorkForm {
  WorkForm(super.metadata, super.current, super.parent){
    speciesTypes = [];
  }

}
