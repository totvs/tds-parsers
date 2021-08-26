module.exports = {
  verbose: true,
  collectCoverage: false,
  collectCoverageFrom: ['src/**/*.js', '!<rootDir>/node_modules/'],
  coverageDirectory: './coverage/',
  setupFiles: ['<rootDir>/tests_config/run_spec.js'],
  testEnvironment: 'node',
  testRegex: 'jsfmt\\.spec\\.js$|__tests__/.*\\.js$',
  transform: {},
  watchPlugins: ['jest-watch-typeahead/filename'],
};
