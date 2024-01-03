/// 分组菜单类型
enum MenuType {
  dict("字典"),
  species("分类"),
  form("表单"),
  property("属性"),
  propPackage("类别属性"),
  dictPackage("类别字典"),
  formPackage("类别表单"),
  authority("权限"),
  template("业务设置");

  final String label;

  const MenuType(this.label);
}

/// 分组菜单类型
enum GroupMenuType {
  dictGroup("字典定义"),
  standardGroup("数据标准"),
  authority("权限定义"),
  innerAgency("内部机构"),
  outAgency("组织群组"),
  friends("我的好友"),
  cohort("外部群组"),
  station("单位岗位"),
  resouceSetting("资源设置"),
  template("业务设置"),
  pageDesignList("门户页面"),
  pageCompList("门户组件");

  final String label;

  const GroupMenuType(this.label);
}
