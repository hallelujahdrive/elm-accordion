import commonjs from "@rollup/plugin-commonjs";
import scss from "rollup-plugin-scss";
import { terser } from "rollup-plugin-terser";
import typescript from "@rollup/plugin-typescript";

export default {
    "input": "src/elm-accordion.ts",
    "output": [
        {
            file: "dist/elm-accordion.common.js",
            format: "cjs"
        },
        {
            file: "dist/elm-accordion.esm.js",
            format: "es"
        },
        {
            file: "dist/elm-accordion.min.js",
            format: "iife",
        }
    ],
    plugins: [
        commonjs(),
        typescript({
            lib: ["es5", "dom"]
        }),
        terser(),
        scss({
            output: "dist/elm-accordion.min.css",
            outputStyle: "compressed"
        })
    ]
}