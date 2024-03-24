/// Copyright flutter_ecosed
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///   http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
library flutter_ecosed;

import 'package:flutter/material.dart';

abstract class EcosedPlugin {
  ///插件信息
  String pluginChannel();

  ///插件名称
  String pluginName();

  ///插件描述
  String pluginDescription();

  ///插件作者
  String pluginAuthor();

  ///插件界面
  Widget pluginWidget(BuildContext context);

  ///方法调用
  Future<Object?> onMethodCall(String name);
}
