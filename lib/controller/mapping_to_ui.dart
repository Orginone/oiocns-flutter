import 'package:flutter/material.dart';

abstract class MappingToUI<W extends Widget> {
  W mapping();
}
