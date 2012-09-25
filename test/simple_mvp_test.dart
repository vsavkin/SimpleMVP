#library("simple_mvp_test");

#import("package:unittest/unittest.dart");
#import("package:unittest/html_enhanced_config.dart");
#import('../lib/simple_mvp.dart');

#import('dart:html');

#source("utils.dart");
#source("events_test.dart");
#source("model_attributes_test.dart");
#source("model_test.dart");
#source("model_list_test.dart");

main(){
  useHtmlEnhancedConfiguration();

  testModels();
  testEvents();
  testModelAttributes();
  testModelLists();
}