part of vint;

typedef bool Condition(Model t);

typedef Map<String, List> Errors(Model t);

abstract class Validator {
  Map<String, List> validate(Model model);
}

class CustomValidator implements Validator {
  Condition _condition;
  Errors _errors;

  CustomValidator(this._condition, this._errors);

  Map<String, List> validate(Model model)
    => _condition(model) ? {} :  _errors(model);
}

class CompositeValidator implements Validator {
  final List parts = [];

  Map<String, List> validate(Model model){
    var errors = parts.mappedBy((_) => _.validate(model));
    return _mergeErrors(errors);
  }

  _mergeErrors(errors){
    return errors.reduce({}, (memo, curr){
      curr.forEach((field, fieldErrors){
        memo.putIfAbsent(field, () => []);
        memo[field].addAll(fieldErrors);
      });
      return memo;
    });
  }
}

class Validations {
  final _composite = new CompositeValidator();

  void addValidator(Validator validator){
    _composite.parts.add(validator);
  }

  void add(Condition condition, Errors errors){
    addValidator(new CustomValidator(condition, errors));
  }

  Map<String, List> validate(Model model){
    var errors = _composite.validate(model);
    model.events.fireValidation(errors);
    return errors;
  }
}

class PresenceValidator implements Validator{
  String attr;

  PresenceValidator(this.attr);

  Map<String, List> validate(Model model){
    var a = model[attr];
    if(a == null) return _errorMsg;
    if((a is String) && a.isEmpty) return _errorMsg;
    return {};
  }

  get _errorMsg {
    var r = {};
    r[attr] = ["${attr} cannot be blank"];
    return r;
  }
}

class NumericalityValidator implements Validator{
  String attr;

  NumericalityValidator(this.attr);

  Map<String, List> validate(Model model){
    try {
      var a = model[attr];
      if(a != null) int.parse(a);
      return {};
    } on FormatException{
      return _errorMsg;
    }
  }

  get _errorMsg {
    var r = {};
    r[attr] = ["${attr} is not a number"];
    return r;
  }
}

class ValidationsBuilder {
  Validations validations = new Validations();

  presence(String attr){
    validations.addValidator(new PresenceValidator(attr));
    return this;
  }

  numericality(String attr){
    validations.addValidator(new NumericalityValidator(attr));
    return this;
  }

  of(Model model) => validations.validate(model);
}

ValidationsBuilder validate() => new ValidationsBuilder();