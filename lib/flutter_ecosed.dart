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

import 'src/platform/flutter_ecosed_method_channel.dart';
import 'src/platform/flutter_ecosed_platform.dart';

export 'src/app/app.dart';
export 'src/plugin/plugin.dart';

class FlutterEcosed extends FlutterEcosedPlatform {
  FlutterEcosed();

  static void registerWith() {
    FlutterEcosedPlatform.instance = MethodChannelFlutterEcosed();
  }
}
