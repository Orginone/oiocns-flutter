

import 'package:orginone/dart/core/thing/base/species.dart';


abstract class IReportBI extends ISpeciesItem {}

class ReportBI extends SpeciesItem implements IReportBI {
  ReportBI(super.metadata, super.current,super.parent){
   speciesTypes = [];
  }

}