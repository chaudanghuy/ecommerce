// next.config.js

module.exports = {
    webpackDevMiddleware: (config) => {
      // Enable hot reloading in Docker container
      config.watchOptions = {
        poll: 1000, // Check for changes every second
        aggregateTimeout: 300, // Delay before rebuilding
      };
      return config;
    },
  };