
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/test_steps.dart';

Future<void> main() {

  //loginInfo = true;

  final config = FlutterTestConfiguration()
    ..features = [Glob(r'./features/**.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ]
    ..stepDefinitions = [
      /*onScreen(),
      tap(),
      see(),*/
      TapByKey(),
      KeyPresent(),
      WriteCredentials(),
      AndTapByKey()
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
    //..defaultTimeout= Duration(seconds: 10);
  return GherkinRunner().execute(config);
}
