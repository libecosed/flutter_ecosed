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

import 'plugin_type.dart';

class PluginDetails {
  const PluginDetails({
    required this.channel,
    required this.title,
    required this.description,
    required this.author,
    required this.type,
    required this.initial,
  });

  final String channel;
  final String title;
  final String description;
  final String author;
  final PluginType type;
  final bool initial;

  factory PluginDetails.formJSON({
    required Map<String, dynamic> json,
    required PluginType type,
    required bool initial,
  }) {
    return PluginDetails(
      channel: json['channel'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      type: type,
      initial: initial,
    );
  }
}
