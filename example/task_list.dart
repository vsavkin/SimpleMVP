import 'dart:html';
import 'package:vint/vint.dart' as smvp;

class TasksRepository extends smvp.Repository<Task> {
  TasksRepository(storage) : super(storage);
  makeInstance(attrs) => new Task(attrs);
}

class Tasks extends smvp.ModelList<Task> {
}

class Task extends smvp.Model {
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

taskListTemplate(c) => """
<div id="tasks">
</div>
""";




class TaskPresenter extends smvp.Presenter<Task> {
  Tasks tasks;
  TasksRepository repo;

  TaskPresenter(this.repo, this.tasks, task, el) : super(task, el, oneTaskTemplate);

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

class NewTaskPresenter extends smvp.Presenter {
  TasksRepository repo;
  Tasks tasks;

  NewTaskPresenter(this.repo, this.tasks, el) :super(null, el, newTaskTemplate);

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

class TasksPresenter extends smvp.Presenter<Tasks>{
  TasksRepository repo;

  TasksPresenter(this.repo, tasks, el) : super(tasks, el, taskListTemplate){
    repo.find().then((list) => model.reset(list));
  }

  subscribeToModelEvents(){
    model.events.onReset.listen(_rerenderTasks);
    model.events.onInsert.listen(_rerenderTasks);
    model.events.onRemove.listen(_rerenderTasks);
  }

  _rerenderTasks(event){
    var t = el.query("#tasks");
    t.elements.clear();
    
    _buildPresenters().forEach((v){
      t.elements.add(v.render().el);
    });
  }
  
  _buildPresenters() => modelList.map((t) => _buildPresenter(t));
  _buildPresenter(t) => new TaskPresenter(repo, modelList, t, new Element.tag("li"));
}

main() {
  var storage = new smvp.RestfulStorage({
    "find": "/api/tasks",
    "read": "/api/task",
    "create": "/api/tasks",
    "update": "/api/task",
    "destroy": "/api/task"
  });

  var repo = new TasksRepository(storage);
  var tasks = new Tasks();

  var newTaskPresenter = new NewTaskPresenter(repo, tasks, new Element.tag("div"));
  var tasksPresenter = new TasksPresenter(repo, tasks, new Element.tag("div"));
  
  query("#container").elements.addAll([newTaskPresenter.render().el, tasksPresenter.render().el]);
}