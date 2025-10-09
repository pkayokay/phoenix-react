import js from "@eslint/js";
import perfectionist from "eslint-plugin-perfectionist";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import pluginReact from "eslint-plugin-react";
import { defineConfig } from "eslint/config";
import globals from "globals";
import tseslint from "typescript-eslint";

export default defineConfig([
  {
    // Needs to take precedence over included files
    ignores: ["js/app.js", "js/application.jsx", "vendor/**/*"],
  },
  { extends: ["js/recommended"], files: ["**/*.{js,mjs,cjs,ts,mts,cts,jsx,tsx}"], languageOptions: { globals: globals.browser }, plugins: { js } },
  tseslint.configs.recommended,
  pluginReact.configs.flat.recommended,
  // Eslint runs prettier rules, so prettier does not need to be executed independently
  // https://github.com/prettier/eslint-plugin-prettier
  eslintPluginPrettierRecommended,
  {
    rules: {
      "react/react-in-jsx-scope": "off",
    },
  },
  perfectionist.configs["recommended-alphabetical"],
  {
    settings: {
      react: {
        version: "detect",
      },
    },
  },
]);
