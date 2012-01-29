
define(['data/mock/actors/allActors'], function(actors) {
  var i, networks, result, show, shows, _, _len;
  _ = function(o) {
    return o;
  };
  networks = ['AMC', 'ABC', 'FOX', 'NBC', 'FX', 'CBS'];
  shows = ['Mad Men', 'Falling Skies', 'Game of Thrones', 'Sherlock', 'Heroes', '24', 'Awakening', 'Breaking Bad', 'Wilfred', 'The Wire', 'The Big Bang Theory', 'Lost', 'Camelot', 'The Borgias', 'The Walking Dead', 'Vampire Diaries', 'MI6', 'Boardwalk Empire', 'FRONTLINE', 'American Experience', 'Modern Marvels', 'Mythbusters'];
  result = {};
  for (i = 0, _len = shows.length; i < _len; i++) {
    show = shows[i];
    result[i] = {
      id: i,
      title: show,
      year: 2007 + i % 4,
      network: networks[i % networks.length],
      description: "[" + i + "] " + show + " - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever \nsince the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but \nalso the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing \nLorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n",
      cast: actors
    };
  }
  return result;
});
