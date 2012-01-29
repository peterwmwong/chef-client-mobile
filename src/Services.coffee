define [
  'data/UserService'
  'data/ActorService'
  'data/ShowService'
], (UserService,ActorService,ShowService)->

  user: UserService
  show: ShowService
  actor: ActorService