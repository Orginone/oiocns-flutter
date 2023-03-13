import { XDict, XFlowDefine } from "@/ts/base/schema";
import { kernel, model, parseAvatar, schema } from "../../base";
import {
  AttributeModel,
  CreateDefineReq,
  DictModel,
  OperationModel,
  PageRequest,
  SpeciesModel,
  TargetShare,
} from "../../base/model";
import { Dict } from "./dict";
import { IDict, INullDict } from "./idict";
import { INullSpeciesItem, ISpeciesItem } from "./ispecies";
/**
 * 分类系统项实现
 */
export class SpeciesItem implements ISpeciesItem {
  id: string;
  name: string;
  isRoot: boolean;
  target: schema.XSpecies;
  parent: INullSpeciesItem;
  children: ISpeciesItem[];
  belongInfo: TargetShare;
  constructor(target: schema.XSpecies, parent: INullSpeciesItem) {
    this.children = [];
    this.target = target;
    this.parent = parent;
    this.id = target.id;
    this.name = target.name;
    this.isRoot = parent === undefined;
    if (target.nodes && target.nodes.length > 0) {
      for (const item of target.nodes) {
        this.children.push(new SpeciesItem(item, this));
      }
    }
    this.belongInfo = { name: "奥集能平台", typeName: "平台" };
  }
  async loadAttrs(
    id: string,
    recursionOrg: boolean,
    recursionSpecies: boolean,
    page: PageRequest
  ): Promise<schema.XAttributeArray> {
    const res = await kernel.querySpeciesAttrs({
      id: this.id,
      spaceId: id,
      recursionOrg: recursionOrg,
      recursionSpecies: recursionSpecies,
      page: {
        offset: page.offset,
        limit: page.limit,
        filter: "",
      },
    });
    return res.data;
  }

  async loadDicts(
    id: string,
    recursionOrg: boolean,
    recursionSpecies: boolean,
    page: PageRequest
  ): Promise<schema.XDictArray> {
    const res = await kernel.querySpeciesDict({
      id: this.id,
      spaceId: id,
      recursionOrg: recursionOrg,
      recursionSpecies: recursionSpecies,
      page: {
        offset: page.offset,
        limit: page.limit,
        filter: "",
      },
    });
    return res.data;
  }

  async loadDictsEntity(
    spaceId: string,
    recursionOrg: boolean,
    recursionSpecies: boolean,
    page: PageRequest
  ): Promise<IDict[]> {
    const res = await kernel.querySpeciesDict({
      id: this.id,
      spaceId: spaceId,
      recursionOrg: recursionOrg,
      recursionSpecies: recursionSpecies,
      page: {
        offset: page.offset,
        limit: page.limit,
        filter: "",
      },
    });
    return (
      res.data.result?.map((item: XDict) => {
        return new Dict(item);
      }) || []
    );
  }

  async loadOperations(
    id: string,
    filterAuth: boolean,
    recursionOrg: boolean,
    recursionSpecies: boolean,
    page: PageRequest
  ): Promise<schema.XOperationArray> {
    const res = await kernel.querySpeciesOperation({
      id: this.id,
      spaceId: id,
      filterAuth,
      recursionOrg,
      recursionSpecies,
      page: {
        offset: page.offset,
        limit: page.limit,
        filter: "",
      },
    });
    return res.data;
  }

  async loadFlowDefines(
    id: string,
    page: PageRequest
  ): Promise<schema.XFlowDefineArray> {
    const res = await kernel.queryDefine({
      speciesId: this.target.id,
      spaceId: id,
      page: {
        offset: page.offset,
        limit: page.limit,
        filter: "",
      },
    });
    return res.data;
  }

  async loadInfo(info: TargetShare): Promise<ISpeciesItem> {
    if (info.typeName != "未知") {
      this.belongInfo = info;
    }
    if (!this.belongInfo && this.target.belongId) {
      const res = await kernel.queryNameBySnowId(this.target.belongId);
      if (res.success && res.data) {
        this.belongInfo = {
          name: res.data.name,
          typeName: "未知",
        } as TargetShare;
        const avator = parseAvatar(res.data.photo);
        if (avator) {
          this.belongInfo = {
            ...avator,
            name: res.data.name,
            typeName: "未知",
          };
        }
      }
    }
    return this;
  }

  async create(
    data: Omit<SpeciesModel, "id" | "parentId">
  ): Promise<INullSpeciesItem> {
    const res = await kernel.createSpecies({
      parentId: this.id,
      ...data,
      id: undefined,
    });
    if (res.success) {
      const newItem = new SpeciesItem(res.data, this);
      this.children.push(newItem);
      return newItem;
    }
    return;
  }

  async createDict(
    data: Omit<DictModel, "id" | "parentId">
  ): Promise<INullDict> {
    const res = await kernel.createDict({
      ...data,
      id: undefined,
      speciesId: this.id,
    });
    if (res.success) {
      const newItem = new Dict(res.data);
      return newItem;
    }
    return;
  }

  async updateDict(data: DictModel): Promise<boolean> {
    const res = await kernel.updateDict({
      ...data,
    });
    return res.success;
  }

  async update(
    data: Omit<SpeciesModel, "id" | "parentId" | "code">
  ): Promise<ISpeciesItem> {
    const res = await kernel.updateSpecies({
      ...data,
      id: this.id,
      code: this.target.code,
      parentId: this.target.parentId,
    });
    if (res.success) {
      this.target.name = data.name;
      this.target.public = data.public;
      this.target.authId = data.authId;
      this.target.belongId = data.belongId;
      this.target.remark = data.remark;
    }
    return this;
  }
  async delete(): Promise<boolean> {
    const res = await kernel.deleteSpecies({
      id: this.id,
      typeName: "",
    });
    if (res.success && this.parent) {
      this.parent.children = this.parent.children.filter((i) => {
        return i.id != this.id;
      });
    }
    return res.success;
  }
  async createAttr(
    data: Omit<AttributeModel, "id" | "speciesId" | "speciesCode">
  ): Promise<boolean> {
    const res = await kernel.createAttribute({
      id: undefined,
      speciesId: this.id,
      speciesCode: this.target.code,
      ...data,
    });
    return res.success;
  }
  async updateAttr(
    data: Omit<AttributeModel, "speciesId" | "speciesCode">
  ): Promise<boolean> {
    const res = await kernel.updateAttribute({
      ...data,
      speciesId: this.target.id,
      speciesCode: this.target.code,
    });
    return res.success;
  }
  async deleteAttr(id: string): Promise<boolean> {
    const res = await kernel.deleteAttribute({
      id: id,
      typeName: "",
    });
    return res.success;
  }

  async createOperation(
    data: Omit<OperationModel, "id" | "speciesId" | "speciesCode">
  ): Promise<model.ResultType<schema.XOperation>> {
    return await kernel.createOperation({
      id: undefined,
      speciesId: this.id,
      ...data,
    });
  }

  async updateOperation(data: OperationModel): Promise<boolean> {
    const res = await kernel.updateOperation({
      ...data,
      speciesId: data.speciesId || this.target.id,
    });
    return res.success;
  }

  async deleteOperation(id: string): Promise<boolean> {
    const res = await kernel.deleteOperation({
      id: id,
      typeName: "",
    });
    return res.success;
  }

  async deleteDict(id: string): Promise<boolean> {
    const res = await kernel.deleteDict({
      id: id,
      typeName: "",
    });
    return res.success;
  }

  async createFlowDefine(
    data: Omit<CreateDefineReq, "id" | "speciesId">
  ): Promise<XFlowDefine> {
    const res = await kernel.publishDefine({ ...data, speciesId: this.id });
    return res.data;
  }

  async updateFlowDefine(data: CreateDefineReq): Promise<boolean> {
    const res = await kernel.publishDefine({
      ...data,
    });
    return res.success;
  }

  async deleteFlowDefine(id: string): Promise<boolean> {
    const res = await kernel.deleteDefine({ id });
    return res.success;
  }
}
