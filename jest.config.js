module.exports = {
  verbose: true,
  collectCoverage: false,
  collectCoverageFrom: ["src/**/*.js", "!<rootDir>/node_modules/"],
  coverageDirectory: "./coverage/",
  setupFiles: ["<rootDir>/tests_config/run_spec.js"],
  snapshotSerializers: ["<rootDir>/tests_config/raw-serializer.js"],
  testEnvironment: "node",
  testRegex: "jsfmt\\.spec\\.js$|tests/.*\\.js$",
  transform: {},
  watchPlugins: ["jest-watch-typeahead/filename"],
};
