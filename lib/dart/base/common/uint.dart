/* eslint-disable no-unused-vars */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

class Constants {
  /// MAX SMI (SMall Integer) as defined in v8.
  /// one bit is lost for boxing/unboxing flag.
  /// one bit is lost for sign flag.
  /// See https://thibaultlaurens.github.io/javascript/2013/04/29/how-the-v8-engine-works/#tagged-values

  static const maxSafeSmallInterger = (1 << 30);

  /// MIN SMI (SMall Integer) as defined in v8.
  /// one bit is lost for boxing/unboxing flag.
  /// one bit is lost for sign flag.
  /// See https://thibaultlaurens.github.io/javascript/2013/04/29/how-the-v8-engine-works/#tagged-values

  static const minSafeSmallInterger = -(1 << 30);

  /// Max unsigned integer that fits on 8 bits.

  static const maxUint8 = 255; // 2^8 - 1

  /// Max unsigned integer that fits on 16 bits.

  static const maxUint16 = 65535; // 2^16 - 1

  /// Max unsigned integer that fits on 32 bits.

  static const maxUint32 = 4294967295; // 2^32 - 1

  static const unicodeSupplementaryPlaneBegin = 0x010000;
}

int toUint8(int v) {
  if (v < 0) {
    return 0;
  }
  if (v > Constants.maxUint8) {
    return Constants.maxUint8;
  }
  return v | 0;
}

int toUint32(int v) {
  if (v < 0) {
    return 0;
  }
  if (v > Constants.maxUint32) {
    return Constants.maxUint32;
  }
  return v | 0;
}
