import thingCtrl from '@/ts/controller/thing';
import { DomainTypes, emitter, ICompany, IDepartment } from '@/ts/core';
import { Emitter } from '@/ts/base/common';
import userCtrl from '@/ts/controller/setting';
import setting from '@/ts/controller/setting';
import { kernel } from '@/ts/base';
interface CateType {
  id: string;
  title: string;
  code: string;
  level: number;
  children?: CateType[];
}
class AssetController extends Emitter {
  private _personList: any[] = []; //人员数据
  private _deptList: any[] = []; //部门数据
  private _categoryList: any[] = []; //分类数据
  private curSpace: ICompany | undefined; //当前 单位
  private _categoryNameMap: Map<string, string> = new Map(); //分类 id=>名称
  private _membersMap: Map<string, any[]> = new Map(); //部门 id=>成员
  private _categorys_GB: CateType[] = [];
  constructor() {
    super();
    this.getTenantDept();
    this.getCategoryTree();
    this.getGBCategoryTree();
    emitter.subscribePart([DomainTypes.User, DomainTypes.Company], () => {
      setTimeout(async () => {
        this.curSpace = userCtrl.isCompanySpace ? userCtrl.company : undefined;
        this.getTenantDept();
        this.getCategoryTree();
        this.getGBCategoryTree();
      }, 200);
    });
  }

  public get persons(): any[] {
    return this._personList;
  }
  public get department(): any[] {
    return this._deptList;
  }

  public get categorys(): any[] {
    return this._categoryList;
  }
  public get categorys_GB(): any[] {
    return this._categorys_GB;
  }
  public get categoryNameMap(): Map<string, string> {
    return this._categoryNameMap;
  }

  /**
   * 获取资产列表
   * @param params
   */

  loopData: any = (
    list: any[],
    target: string = 'target',
    childName: string = 'children',
    title: string = 'name',
    id: string = 'id',
    code: string = 'code',
    typeName: '部门' | '人员' | '分类' = '部门',
  ) => {
    if (list && list?.length > 0) {
      const result = list.map((item: any) => {
        let obj: any = {};
        if (typeName === '分类') {
          this._categoryNameMap.set(item.target.code, item.target.name);
        }

        let child: any[] = [];
        if (item[childName]?.length > 0) {
          child = this.loopData(
            item[childName],
            target,
            childName,
            title,
            id,
            code,
            typeName,
          );
        }
        if (item[target]) {
          obj = {
            title: item[target][title],
            id: item[target][id],
            code: item[target][code],
            typeName: item[target]['typeName'] || typeName,
          };
        } else {
          obj = {
            title: item[title] || '--',
            id: item[id],
            code: item[code],
            typeName: typeName,
          };
        }
        obj.children = child;

        if (!['分类', '人员'].includes(item?.target?.typeName)) {
          obj.members = item?.members || [];
        }

        return obj;
      });
      return result;
    }
    return [];
  };
  public getTenantDept = async () => {
    const depts = (await this.curSpace?.getDepartments()) || [];
    const loop = async (_depts: (IDepartment & { members?: any[] })[]) => {
      for (let i = 0; i < _depts?.length; i++) {
        _depts[i].departments = (await _depts[i].loadSubTeam()) as any;
        _depts[i].members = (
          await _depts[i].loadMembers({
            offset: 0,
            limit: 20000,
            filter: '',
          })
        )?.result?.map((item, index) => {
          return {
            // title: item.name || '--',
            title: item.team?.name,
            realName: item.team?.name,
            nickName: item.name || '--',
            id: item.id,
            key: _depts[i].id + '&&' + item.id + '--' + index,
            code: item.code || '--',
            typeName: item.typeName || '人员',
          };
        });
        if (_depts[i].departments && _depts[i].departments.length) {
          loop(_depts[i].departments);
        }
      }
    };
    await loop(depts);

    this._deptList = this.loopData(
      depts,
      'target',
      'departments',
      'name',
      'id',
      'code',
      '部门',
    );
    this._personList = this._deptList;
  };

  public getCategoryTree = async () => {
    let arr: any = await thingCtrl.loadTeamSpecies(this.curSpace?.target?.id || '');
    if (!arr?.children.length) return;
    this._categoryList = this.loopData(
      arr.children,
      'target',
      'children',
      'name',
      'id',
      'code',
      '分类',
    );
    console.log('sssCategoryNameMap', this._categoryList);
  };

  // async querydeptMembers(target: IDepartment) {
  //   let res = await target.loadMembers({ offset: 0, limit: 2000, filter: '' });
  //   this._membersMap.set(
  //     target.id,
  //     res?.result?.map((v) => {
  //       console.log('人员', v);

  //       return {
  //         id: v.id,
  //         code: v.code,
  //         key: v.code,
  //         title: v.name,
  //         typeName: '人员',
  //       };
  //     }) || [],
  //   );

  //   console.log('成员数据', this._membersMap);
  // }
  // 根据value区分国标等级
  private categoryLV: (value: string) => number = (value: string, maxLength = 8) => {
    let lv = 4;
    for (let i = 0; i < maxLength / 2; i++) {
      // let beforeStr = value.substring(0, i + 2);
      let afterStr: string = value.substring((i + 1) * 2, value.length);
      // console.log('uuuu', value, afterStr);

      if (afterStr && afterStr == 0) {
        lv = i + 1;
        return lv;
      }
      if (i == 3 && afterStr && afterStr > 0) {
        return 5;
      }
    }
    // console.log('等级2', value, 444, lv);

    return lv;
  };

  getGBCategoryTree = async () => {
    kernel
      .queryDictItems({
        id: '27466608056615936',
        spaceId: setting.space.id,
        page: {
          offset: 0,
          limit: 10000,
          filter: '',
        },
      })
      .then((res) => {
        const { success, data } = res;
        if (success) {
          const { result = [] } = data;
          this.handleGroupCategory(result);
        }
      });
  };
  private handleGroupCategory = (categoryArr: any[], maxLength = 8) => {
    let AllData = {}; //国标数据分级存放
    let OverArr: CateType[] = []; //非国标数据
    // let reslut: CateType[] = []; //输出结果
    // 设置默认存放位置
    for (let max = 0; max < 4; max++) {
      AllData[max + 1] = [];
    }

    //第一步： 初步分组
    categoryArr.forEach((item) => {
      if (!item?.value || item?.value?.length === 0) {
        return;
      }
      let obj: CateType = {
        title: item.name,
        code: item.value,
        level: this.categoryLV(item.value),
        id: item.id,
        children: [],
      };
      // console.log('GBTypesMap', item.value, categoryLV(item.value));
      // 排除非国标类型
      if (item?.value?.length > maxLength) {
        OverArr.push(obj);
      } else {
        AllData[this.categoryLV(item.value)].push(obj);
      }
    });
    //第二部 处理层级
    // console.log('AllData', AllData);
    for (let v = 0; v < maxLength / 2; v++) {
      //4-3-2-1
      const element = maxLength / 2 - v;
      let targetArr: CateType[] = AllData[element];
      let parentArr: CateType[] = AllData[element - 1];
      let str0 = '00000000';
      let parentObj = {};
      for (let e = 0; e < targetArr.length; e++) {
        const item = targetArr[e];
        const key =
          item.code.substring(0, (element - 1) * 2) + str0.substring(0, (v + 1) * 2);

        if (parentObj[key]) {
          parentObj[key]['children'].push(item);
        } else {
          let aimObj = parentArr?.find((o) => o.code === key);

          if (!aimObj) {
            OverArr.push(item);
          } else {
            aimObj!.children!.push(item);
          }
        }
      }
      // console.log('9999', parentObj, AllData);
    }

    // return AllData[1];
    this._categorys_GB = AllData[1];
    console.log('国标数据', this._categorys_GB);
  };
}
export default new AssetController();
