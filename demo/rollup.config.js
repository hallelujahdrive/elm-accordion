import commonjs from "@rollup/plugin-commonjs";
import scss from "rollup-plugin-scss";
import { terser } from "rollup-plugin-terser";
import typescript from "@rollup/plugin-typescript";
import elm from "rollup-plugin-elm";

export default {
    input: "./demo.ts",
    output:  {
        file: "./demo.js",
        format: "iife",
        globals: {
            "elm-accordion": "ElmAccordion"
        }
    },
    external: ["elm-accordion"],
    plugins: [
        commonjs(),
        elm({
            exclude: ["./elm-stuff/**"],
            compiler: {
                optimize: true,
                debug: false,
            },
        }),
        typescript({
            lib: ["es5", "dom"],
        }),
        terser(),
        scss({
            output: "demo.css",
            outputStyle: "compressed"
        })
    ]
}