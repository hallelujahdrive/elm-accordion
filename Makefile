all: build-demo

build-npm: node_modules src/elm-accordion.ts
	rollup -c

build-demo: build-npm
	cp dist/elm-accordion.min.js demo
	cp dist/elm-accordion.min.css demo
	cd demo && rollup -c

build-docs: src/*.elm
	elm make --docs=docs.json

release : clean all

clean:
	rm -rf dist
	rm -f docs.json
	rm -f demo/demo.js
	rm -f demo/elm-accordion.min.js
	rm -f demo/elm-accordion.min.css