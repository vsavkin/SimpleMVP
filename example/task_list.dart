import 'dart:html';
import 'package:vint/vint.dart';

class TasksRepository extends Repository<Task> {
  TasksRepository(storage) : super(storage);
  makeInstance(attrs) => new Task(attrs);
}

class Tasks extends ModelList<Task> {
}

class Task extends Model {
  Task(attrs): super(attrs);
  Task.fromText(String text): this({"text": text, "status": "inProgress"});

  get isCompleted => status == "completed";

  complete(){
    status = "completed";
  }

  inProgress(){
    status = "inProgress";
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



class TaskPresenter extends TemplateBasedPresenter<Task> {
  Tasks tasks;
  TasksRepository repo;

  TaskPresenter(this.repo, this.tasks, task, el) : super(task, el);
  
  get template => oneTaskTemplate;

  subscribeToModelEvents() {
    model.events.onChange.listen(_onChange);
  }

  _onChange(e){
    render();
    el.query(".text").classes.add("done-${model.isCompleted}");
  }

  get events => {
    "click a.delete": _onDelete,
    "click a.complete": _onComplete
  };

  _onDelete(event){
    tasks.remove(model);
    repo.destroy(model);
  }

  _onComplete(event){
    model.isCompleted ? model.inProgress() : model.complete();
    repo.save(model);
  }
}

class NewTaskPresenter extends TemplateBasedPresenter<Tasks> {
  TasksRepository repo;
  Tasks tasks;

  NewTaskPresenter(this.repo, this.tasks, el) : super(null, el);

  get template => newTaskTemplate;
  
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
    tasks.add(task);
    repo.save(task);

    textField.value = "";
  }
}

class TasksPresenter extends CollectionPresenter<Tasks> {
  TasksRepository repo;

  makeItemPresenter(t) => new TaskPresenter(repo, modelList, t, new Element.tag("li"));

  TasksPresenter(this.repo, tasks, el) : super(tasks, el){
    repo.find().then((list) => model.reset(list));
  }

  subscribeToModelEvents(){
    model.events.onReset.listen((_) => render());
    model.events.onInsert.listen((_) => render());
    model.events.onRemove.listen((_) => render());
  }
}

main() {
  var storage = new RestfulStorage({
    "find": "/api/tasks",
    "read": "/api/task",
    "create": "/api/tasks",
    "update": "/api/task",
    "destroy": "/api/task"
  });

  var repo = new TasksRepository(storage);
  var tasks = new Tasks();

  var newTaskPresenter = new NewTaskPresenter(repo, tasks, new Element.tag("div"));
  var tasksPresenter = new TasksPresenter(repo, tasks, new Element.tag("ul"));

  query("#container").children.addAll([newTaskPresenter.render().el, tasksPresenter.render().el]);
}