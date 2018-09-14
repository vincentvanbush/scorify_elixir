module.exports = {
  env: {
      browser: true,
      mocha: true,
      es6: true
  },
  extends: [
      "eslint:recommended",
      "plugin:react/recommended"
  ],
  parserOptions: {
      sourceType: "module"
  },
  plugins: ["react"],
  rules: {
      "no-empty": "warn",
      "max-params": ["warn", 4],
      "max-statements": ["error", 30],
      "max-depth": ["error", 3],
      complexity: ["error", 6],
      "max-len": ["error", 200],
      curly: ["error", "all"],
      quotes: ["error", "double"],
      "newline-per-chained-call": "error",
      "prefer-const": "error",
      eqeqeq: "error",
      "require-yield": "error",
      "no-caller": "error",
      "no-eval": "error",
      "no-implied-eval": "error",
      "no-eq-null": "error",
      "no-multi-str": "error",
      "no-shadow-restricted-names": "error",
      "no-sync": "warn",
      "no-iterator": "error",
      "no-proto": "error",
      "no-script-url": "error",
      "no-new-func": "error",
      "no-new-object": "error",
      "no-self-compare": "error",
      "object-curly-spacing": ["warn", "always"]
  },
  "globals": {
      "Enzyme": true,
      "helpers": true
  }
};
