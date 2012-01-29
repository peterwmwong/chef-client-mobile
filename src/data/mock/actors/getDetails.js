
define(['data/mock/actors/allActors', 'data/mock/getPathComponent'], function(actors, getPathComponent) {
  return function(path) {
    return actors[getPathComponent(path)];
  };
});
