
define(['data/UserService', 'data/ActorService', 'data/ShowService'], function(UserService, ActorService, ShowService) {
  return {
    user: UserService,
    show: ShowService,
    actor: ActorService
  };
});
