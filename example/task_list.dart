import 'dart:html';
import 'package:simple_mvp/simple_mvp.dart' as smvp;

class Tasks extends smvp.ModelList<Task>{
  final rootUrl = "/api/tasks";

  makeInstance(attrs, list) => new Task(attrs, list);
}

class Task extends smvp.Model {
  Task(attrs, modelList): super(attrs, modelList);
  Task.fromText(String text): this({"text": text, "status": "inProgress"}, null);
  
  final rootUrl = "/api/task";
  final createUrl = "/api/tasks";

  get isCompleted => status == "completed";

  complete(){
    status = "completed";
    save();
  }

  inProgress(){
    status = "inProgress";
    save();
  }
}




oneTaskTemplate(c) => """
<div class="well well-small">
  <span class="text">${c.text}</span>
  <span class="actions">
    <a class="complete" href="#">[DONE]</a>
    <a class="delete" href="#">[DELETE]</a>
  </span>
</div>
""";

newTaskTemplate(c) => """
<div class="well well-small">
  <input type="text" class="task-text"/>
  <button class="btn">Create!</button>
</div>
""";

taskListTemplate(c) => """
<div id="tasks">
</div>
""";




class TaskPresenter extends smvp.Presenter<Task> {
  TaskPresenter(task, el) : super(task, el, oneTaskTemplate);

  subscribeToModelEvents() {
    model.on.change.add(_onChange);
  }

  _onChange(e){
    render();
    el.query(".text").classes.add("done-${model.isCompleted}");
  }

  get events => {
    "click a.delete": _onDelete,
    "click a.complete": _onComplete
  };

  _onDelete(event) => model.destroy();
  _onComplete(event) => model.isCompleted ? model.inProgress() : model.complete();
}

class NewTaskPresenter extends smvp.Presenter<Tasks> {
  NewTaskPresenter(tasks, el) :super(tasks, el, newTaskTemplate);

  get events => {
    "click button": _addNewTask,
    "keypress input": _maybeAddNewTask
  };

  _maybeAddNewTask(KeyboardEvent event){
    if(event.keyCode == 13){
      _createTask();
    }
  }

  _addNewTask(event){
    _createTask();
  }

  _createTask(){
    var textField = el.query(".task-text");

    var task = new Task.fromText(textField.value);
    model.add(task);
    task.save();

    textField.value = "";
  }
}

class TasksPresenter extends smvp.Presenter<Tasks>{
  TasksPresenter(tasks, el) : super(tasks, el, taskListTemplate){
    model.fetch();
  }

  subscribeToModelEvents(){
    model.on.load.add(_rerenderTasks);
    model.on.insert.add(_rerenderTasks);
    model.on.remove.add(_rerenderTasks);
  }

  _rerenderTasks(event){
    var t = el.query("#tasks");
    t.elements.clear();
    
    _buildPresenters().forEach((v){
      t.elements.add(v.render().el);
    });
  }
  
  _buildPresenters() => model.map((t) => new TaskPresenter(t, new Element.tag("li")));
}

main() {
  var tasks = new Tasks();
  var newTaskPresenter = new NewTaskPresenter(tasks, new Element.tag("div"));
  var tasksPresenter = new TasksPresenter(tasks, new Element.tag("div"));
  
  query("#container").elements.addAll([newTaskPresenter.render().el, tasksPresenter.render().el]);
}