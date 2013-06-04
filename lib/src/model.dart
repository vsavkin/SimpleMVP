part of vint;

/**
* The base class for evented models.
*/
abstract class Model {
  ModelAttributes attributes;

  final ModelEvents events = new ModelEvents();

  Model(Map attributes){
    this.attributes = new ModelAttributes(this, attributes);
  }

  get id => attributes["id"];

  operator [] (String name) => attributes[name];

  operator []= (String name, value) => attributes[name] = value;

  noSuchMethod(Invocation invocation){
    var mName = MirrorSystem.getName(invocation.memberName);
    if(invocation.isGetter){
      return this[mName];
    } else if (invocation.isSetter){
      var propertyName = _removeEqualsSign(mName);
      return this[propertyName] = invocation.positionalArguments[0];
    } else {
      super.noSuchMethod(invocation);
    }
  }

  _removeEqualsSign(String setter)
    => setter.substring(0, setter.length - 1);
}