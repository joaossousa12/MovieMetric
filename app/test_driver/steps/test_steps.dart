import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric onScreen() {
  return given1<String, FlutterWorld>(
    'the {string} screen',
        (screenKey, context) async {
      final keyFinder = find.byValueKey(screenKey);

      await FlutterDriverUtils.isPresent(context.world.driver, keyFinder);
    },
  );
}

StepDefinitionGeneric see() {

  return when1<String, FlutterWorld> (
    'I can see {string}',
        (str, context) async {
      final textFinder = find.text(str);
      await FlutterDriverUtils.isPresent(context.world.driver, textFinder);
    },
  );
}

class TapByKey extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, button);
  }

  @override
  RegExp get pattern => RegExp(r"And I tap the element with the key {string}");
}

class KeyPresent extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final loginfinder = find.byValueKey(key);
    bool isPresent =
    await FlutterDriverUtils.isPresent(world.driver, loginfinder);
    expect(isPresent, true);
  }

  @override
  RegExp get pattern =>
      RegExp(r"And the element with the key {string} is present");
}

class WriteCredentials extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String field, String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.enterText(world.driver, button, field);
  }

  @override
  RegExp get pattern => RegExp(r" I write {string} in {string}");
}

class AndTapByKey extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, button);
  }

  @override
  RegExp get pattern => RegExp(r" I tap the element with key {string}");
}
