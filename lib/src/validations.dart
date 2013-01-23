part of simple_mvp;

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

class Validations {
  final List _validators = [];

  void addValidator(Validator validator){
    _validators.add(validator);
  }

  void add(Condition condition, Errors errors){
    _validators.add(new CustomValidator(condition, errors));
  }

  Map<String, List> validate(Model model){
    var errors = _validators.mappedBy((_) => _.validate(model));
    var mergedErrors = _mergeErrors(errors);
    model.on.validation.dispatch(mergedErrors);
    return mergedErrors;
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