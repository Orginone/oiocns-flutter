import { kernel } from '@/ts/base';
import { Emitter } from '@/ts/base/common';
import moment from 'moment';

// 编码生成器
class BMController extends Emitter {
  constructor() {
    super();
  }


  public generateBm: (type: string) => Promise<string> = async (type: string) => {
    const ymd = moment().format('YYYYMMDD');
    const key = type + '_' + ymd;
    const {
      code,
      data: { count = 0 },
    }: any = await kernel.anystore.get(key, 'company');
    if (code === 200) {
      const _latestCount = count + 1;
      const { code } = await kernel.anystore.set(
        key,
        {
          operation: 'replaceAll',
          data: {
            count: _latestCount,
          },
        },
        'company',
      );
      if (code === 200) {
        const countStr = _latestCount + '';
        return type + ymd + '00000000'.slice(0, 8 - countStr.length) + countStr;
      }
    }
    return '';
  };
  /* 处理批量编号 */
  public moreBm = async (type: string, num: number) => {
    const ymd = moment().format('YYYYMMDD');
    const key = type + '_' + ymd;
    const {
      code,
      data: { count = 0 },
    }: any = await kernel.anystore.get(key, 'company');
    if (code === 200) {
      const _latestCount = count + num + 1;
      const { code } = await kernel.anystore.set(
        key,
        {
          operation: 'replaceAll',
          data: {
            count: _latestCount,
          },
        },
        'company',
      );
      if (code === 200) {
        let result = [];
        for (let i = 0; i < num; i++) {
          let countStr = count + 1 + i + '';
          let bill = type + ymd + '00000000'.slice(0, 8 - countStr.length) + countStr;
          result.push(bill);
        }
        // const countStr = _latestCount + '';
        // return type + ymd + '00000000'.slice(0, 8 - countStr.length) + countStr;
        return result;
      }
    }
    return [];
  };
}
export default new BMController();
