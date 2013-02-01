part of vint;

/**
* Exception raised when accessing a missing attribute.
*/
class InvalidAttributeError extends Error {
  var model, name;
  InvalidAttributeError(this.model, this.name);

  String toString() => "InvalidAttributeError: invalid attribute '${name}' for '${model}'";
}

/**
* Utility class to manage a model's attributes.
*/
class ModelAttributes {
  final Model model;
  Map map;

  ModelAttributes(this.model, this.map);

  hasId() => map.containsKey("id");

  operator [] (String name){
    if(! map.containsKey(name)){
      throw new InvalidAttributeError(model, name);
    }
    return map[name];
  }

  operator []= (String name, value){
    if(! map.containsKey(name)){
      throw new InvalidAttributeError(model, name);
    }

    var oldValue = map[name];
    map[name] = value;

    if(value != oldValue){
      var event = new ChangeEvent(model, name, oldValue, value);
      model.events.fireChange(event);
    }
  }

  void reset(Map attrs){
    map = attrs;
  }

  asJSON() => map;
}
