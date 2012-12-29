# SimpleMVP

SimpleMVP is a framework for writing single-page applications in Dart. Similar to Backbone it has the following key components:

* Models
* ModelLists (Collections in Backbone)
* Presenters (Views in Backbone)

## Example App

There is a task list application using SimpleMVP in the example folder.

To try it out:

* Run: dart dummy_server.dart
* Open Dartium: localhost:8080/task_list.html

The application illustrates most of the features of SimpleMVP, and it's about 100 lines long (including all templates). Check out `task_list.dart` to see how it's implemented.

## Video

I've put together a 15-minute video showing how to build a TODO app using SimpleMVP.
[Building a TODO app using SimpleMVP](https://vimeo.com/49728673)

## Learning Dart

Even if you don't end up using SimpleMVP, you can still use it as an example of an MV* framework written in Dart.

## How to use it

### Add the SimpleMVP dependency to your pubspec.yaml

  dependencies:
    simple_mvp: any