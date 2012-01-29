
define(['cell!pages/schedule/Schedule'], function() {
  return {
    contexts: {
      Schedule: {
        defaultPagePath: 'pages/schedule/Schedule'
      },
      Watch: {
        defaultPagePath: 'pages/watch/Watch'
      },
      Search: {
        defaultPagePath: 'pages/watch/Watch'
      }
    },
    defaultContext: 'Schedule'
  };
});
