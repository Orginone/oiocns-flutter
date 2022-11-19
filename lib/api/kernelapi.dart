class KernelApi {
  final Map<String, Function> _methods;


  KernelApi._({required String url}) : _methods = {};
}

late KernelApi? _instance;

KernelApi get kernelApi {
  _instance ??= KernelApi._(url: '/orginone/kernel/hub');
  return _instance!;
}
