/**
 * 后端返回的字段可能和前端需要不符的情况下，用来改变树形结构的key
 * @param list 树形列表
 * @param changeKeys Array<[原始key, 最终key, changeFunc(item[原始key], item)]>
 * @param childrenKey string 默认children
 */
export declare const changeTreePropName: (list: any[], changeKeys: Array<[string, string, Function?]>, childrenKey?: string | undefined) => any;
/**
 *
 * 把线性数据转成树形数据
 * @source 原数据
 * @id string
 * @parentId string
 * @children string
 * @topCode string
 */
export declare function setTreeData(source: any[], id: string, parentId: string, children: string, topCode?: string): any;
/**
 * 根据指定key从主树获取子树，浅拷贝
 * @param tree obj类型
 * @param key 可以是key.key类型
 * @param value
 */
export declare const findSingle: (tree: any, key: string, value: any) => undefined;
/**
 * 根据id从主树获取子树
 * @param key
 * @param treeList list类型
 * @param id
 */
export declare const getMyTreeListById: (key: string, treeList: any[], id: string) => null;
/**
 * 根据id从主树获取子树的所有id列表
 * @param key
 * @param treeList
 * @param id
 */
export declare const getTreeIdsById: (key: string, treeList: any[], id: string) => any[];
/**
 * 扁平化树形(应该可以用flat来扁平化了)
 * @param list tree数组
 */
export declare function getPeerList(list: any): any;
/**
 * 根据字符串筛选tree，底下有的会保存上面的
 * @param origin 原始tree，子集为children
 * @param value 筛选字符串
 * @param key 字符串对比的key
 */
export declare const filterTreeData: (origin: any[], value: string, key: string) => any[];
