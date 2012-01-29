
define(['data/mock/users/allUsers', 'data/mock/PathHelper'], function(allUsers, _arg) {
  var getPathComponents;
  getPathComponents = _arg.getPathComponents;
  return function(path) {
    var api, date, schedule, user, userid, _ref;
    _ref = getPathComponents(path), api = _ref[0], user = _ref[1], userid = _ref[2], schedule = _ref[3], date = _ref[4];
    return allUsers[userid].shows;
  };
});
