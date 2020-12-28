import 'dart:convert';

import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// Provides access to methods for obtaining and updating node state.
class NodeState {
  final String accessToken;
  String _urlBase;

  static const String _nodeState = 'user/nodes/params';

  /// Contructs object to access node state methods.
  ///
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  NodeState(this.accessToken, [APIVersion version = APIVersion.v1]) {
    _urlBase = URLBase.getBase(version);
  }

  /// Updates the state of a node with the given [params].
  ///
  /// Example map input:
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  Future<void> updateState(String nodeId, Map<String, dynamic> params) async {
    final url = _urlBase +
        _nodeState +
        URLBase.getQueryParams({
          'node_id': nodeId,
        });

    final body = jsonEncode(params);

    final resp = await put(
      url,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Obtains the state of the node with id [nodeId].
  ///
  /// Example map output:
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  Future<Map<String, dynamic>> getState(String nodeId) async {
    final url = _urlBase +
        _nodeState +
        URLBase.getQueryParams({
          'nodeid': nodeId,
        });

    final resp = await get(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp;
  }

  /// Helper function for adding a Rainmaker schedule.
  /// 
  /// Takes an [action] parameter that triggers at the
  /// given time. The action parameter is identical to
  /// the parameters used by the other state functions.
  /// 
  /// E.g.
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  Future<void> createSchedule(String nodeId, String name, String id, List<ScheduleTrigger> triggers, Map<String, dynamic> action) async {
    final parsedTriggers = <Map<String, int>>[];
    for(final trigger in triggers) {
      final bitList = <int>[];
      for(final dayOfWeek in trigger.daysOfWeek) {
        final index = DaysOfWeek.values.indexOf(dayOfWeek);
        bitList.add(1<<index);
      }
      
      final combinedBitList = bitList.reduce((val1, val2) {
        return val1 | val2;
      });

      parsedTriggers.add({
        'd': combinedBitList,
        'm': trigger.minutesSinceMidnight,
      });
    }

    await updateState(nodeId, {
      'Schedule': {
        'Schedules': [{
          'name': name,
          'id': id,
          'operation': 'add',
          'triggers': parsedTriggers,
          'action': action,
        }],
      }
    });
  }

  /// Helper function for editing a Rainmaker schedule.
  /// 
  /// Takes an [action] parameter that triggers at the
  /// given time. The action parameter is identical to
  /// the parameters used by the other state functions.
  /// 
  /// E.g.
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  ///
  /// When updating the [action] and [triggers] parameters,
  /// *all*, the objects should be complete. They cannot be partial.
  /// E.g. you should pass `"action":{"Light": {"power": true, "brightness":100}}`
  /// and not just `"action":{"Light": {"brightness":100}}`.
  Future<void> editSchedule(String nodeId, String id, [String name, List<ScheduleTrigger> triggers, Map<String, dynamic> action]) async {
    final parsedTriggers = <Map<String, int>>[];

    if(triggers != null) {
      for(final trigger in triggers) {
        final bitList = <int>[];
        for(final dayOfWeek in trigger.daysOfWeek) {
          final index = DaysOfWeek.values.indexOf(dayOfWeek);
          bitList.add(1<<index);
        }
        
        final combinedBitList = bitList.reduce((val1, val2) {
          return val1 | val2;
        });

        parsedTriggers.add({
          'd': combinedBitList,
          'm': trigger.minutesSinceMidnight,
        });
      }
    }
    
    await updateState(nodeId, {
      'Schedule': {
        'Schedules': [{
          'name': name,
          'id': id,
          'operation': 'edit',
          'triggers': parsedTriggers,
          'action': action,
        }],
      }
    });
  }

  /// Helper function for removing a Rainmaker schedule.
  Future<void> deleteSchedule(String nodeId, String id) async {    
    await updateState(nodeId, {
      'Schedule': {
        'Schedules': [{
          'id': id,
          'operation': 'remove',
        }],
      }
    });
  }

  /// Helper function for change the enable
  /// status of a Rainmaker schedule.
  Future<void> changeEnableSchedule(String nodeId, String id, ScheduleEnableOperation operation) async {    
    await updateState(nodeId, {
      'Schedule': {
        'Schedules': [{
          'id': id,
          'operation': operation.toShortString(),
        }],
      }
    });
  }

  /// Helper function to get the number of minutes from midnight.
  /// 
  /// Useful for passing a schedule to the scheduling functions.
  /// Returns the number of minutes from midnight of the
  /// day of the DateTime object.
  static int getMinutesFromMidnight(DateTime time) {
    final dayStart = DateTime(time.year, time.month, time.day);
    final dur = time.difference(dayStart);
    return dur.inMinutes;
  }
}

/// Details the times at which a schedule event should trigger.
@immutable
class ScheduleTrigger {
  /// Days of week that the action should trigger.
  final List<DaysOfWeek> daysOfWeek;

  /// The time in minutes since midnight that an actions is triggered each [daysOfWeek].
  final int minutesSinceMidnight;

  ScheduleTrigger(this.daysOfWeek, this.minutesSinceMidnight);
}

enum DaysOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

enum ScheduleEnableOperation {
  disable,
  enable,
}

extension ParseEnableOperationToString on ScheduleEnableOperation {
  String toShortString() {
    return toString().split('.').last;
  }
}