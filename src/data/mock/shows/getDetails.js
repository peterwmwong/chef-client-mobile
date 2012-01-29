
define(['data/mock/shows/allShows', 'data/mock/getPathComponent'], function(shows, getPathComponent) {
  return function(path) {
    return shows[getPathComponent(path)];
  };
});
