/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-01 11:59:38
 * @LastEditors: 
 * @LastEditTime: 2022-12-01 12:00:18
 */
/// 转换
/**
oss 图片加工 https://help.aliyun.com/document_detail/101260.html
oss 图片参数 https://help.aliyun.com/document_detail/44688.html
 */
///
class Convert {
  // 阿里图片尺寸调整
  static String aliImageResize(
    String url, {
    double width = 300,
    double? maxHeight,
  }) {
    var crop = '';
    int _width = width.toInt();
    int? _maxHeight = maxHeight?.toInt();

    if (maxHeight != null) {
      crop = '/crop,h_$_maxHeight,g_center';
    }
    return url + '?x-oss-process=image/resize,w_$_width,m_lfit$crop';
  }
}
