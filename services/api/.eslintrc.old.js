module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin', '@typescript-eslint'],
  extends: [
    'standard',
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:json/recommended'
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
    '@typescript-eslint/semi': ['error', 'never'],
    'no-useless-constructor': 0,
    'eol-last': ['error'],
    'brace-style': ['warn', '1tbs', { allowSingleLine: false }],
    curly: ['warn', 'all']
  }
};
