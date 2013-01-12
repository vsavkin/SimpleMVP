library simple_mvp_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/mock.dart';
import 'package:simple_mvp/simple_mvp.dart';

import 'dart:html' as html;

part 'src/utils.dart';
part 'src/events_test.dart';
part 'src/validations_test.dart';
part 'src/model_attributes_test.dart';
part 'src/model_test.dart';
part 'src/model_list_test.dart';
part 'src/repository_test.dart';
part 'src/presenter_test.dart';

main(){
  useHtmlEnhancedConfiguration();

  testModels();
  testEvents();
  testValidations();
  testModelAttributes();
  testModelLists();
  testRepositories();
  testPresenters();
}