
define(function() {
  var actor, actors, i, _, _len, _results;
  _ = function(o) {
    return o;
  };
  actors = ['Jon Hamm', 'Noah Wiley', 'Elisabeth Moss', 'Vincent Kartheiser', 'January Jones', 'Christina Hendricks', 'Aaron Staton', 'Rich Sommer', 'John Slattery'];
  _results = [];
  for (i = 0, _len = actors.length; i < _len; i++) {
    actor = actors[i];
    _results.push(_({
      id: i,
      name: actor,
      born: {
        year: 1975 + i % 10,
        place: 'San Francisco, California'
      },
      knownFor: [
        _({
          id: 0,
          role: 'Actor',
          title: 'Mad Men'
        }), _({
          id: 1,
          role: 'Actor',
          title: 'Falling Skies'
        }), _({
          id: 2,
          role: 'Actor',
          title: 'Game of Thrones'
        })
      ]
    }));
  }
  return _results;
});
