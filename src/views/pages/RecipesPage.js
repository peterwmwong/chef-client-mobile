// Generated by CoffeeScript 1.3.3

define(['__', 'Nav'], function(__, Nav) {
  return {
    initialize: function() {
      return this.model.set('title', 'Recipes');
    },
    render_el: function() {
      var i, _i, _results;
      _results = [];
      for (i = _i = 0; _i <= 100; i = ++_i) {
        _results.push(__('.recipe', "Recipe " + i));
      }
      return _results;
    }
  };
});
