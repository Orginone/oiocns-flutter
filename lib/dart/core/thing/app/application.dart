

import 'appmodule.dart';

abstract class IApplication extends IAppModule {

}

class Application extends AppModule implements IApplication {
  Application(super.metadata, super.current);

}