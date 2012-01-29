#===================================================================
#--------------------------- Variables -----------------------------
#===================================================================
npmbin = node_modules/.bin
coffee = $(npmbin)/coffee
serve= $(npmbin)/serve
stylus = $(npmbin)/stylus
uglifyjs = $(npmbin)/uglifyjs
closure = vendor/closure-compiler/compiler.jar

#-------------------------------------------------------------------
# BUILD
#------------------------------------------------------------------- 
requirejsBuild = node_modules/.bin/r.js


#===================================================================
#­--------------------------- TARGETS ------------------------------
#===================================================================
.PHONY : clean deps

#-------------------------------------------------------------------
# BUILD
#------------------------------------------------------------------- 
src/bootstrap.js: deps src/cell.js src/cell-builder-plugin.js
	$(coffee) -c -b src/
	$(requirejsBuild) \
		-o \
		paths.requireLib=../node_modules/requirejs/require \
		include=requireLib \
		name=cell!framework/App \
		out=src/bootstrap-tmp.js \
		optimize=none \
		baseUrl=src includeRequire=true
	cat node_modules/iscroll/src/iscroll-lite.js \
			src/bootstrap-tmp.js > src/bootstrap-tmp.unmin.js
	java -jar $(closure) --compilation_level SIMPLE_OPTIMIZATIONS --js src/bootstrap-tmp.unmin.js --js_output_file src/bootstrap.js
	cat src/global.css \
			src/bootstrap-tmp.css > src/bootstrap.css
	rm src/bootstrap-tmp.*

#-------------------------------------------------------------------
# DEV 
#------------------------------------------------------------------- 
dev-server: deps
	$(npmbin)/coffee dev-server.coffee ./

dev-stylus: deps
	find ./src ./mixins -name '*.styl' -type f | xargs $(stylus) --include ./src/shared/styles --watch --compress

dev-coffee: deps
	find specs src spec-runner -name '*.coffee' -type f | xargs $(coffee) -c -b --watch

#-------------------------------------------------------------------
# Dependencies 
#------------------------------------------------------------------- 
remove-closure:
	rm -rf vendor/closure-compiler

update-closure: remove-closure $(closure)

$(closure):
	mkdir -p vendor/closure-compiler
	wget -O vendor/closure-compiler/closure-compiler.zip http://closure-compiler.googlecode.com/files/compiler-latest.zip
	unzip -d vendor/closure-compiler vendor/closure-compiler/closure-compiler.zip
	rm vendor/closure-compiler/closure-compiler.zip

deps:
	npm install

#-------------------------------------------------------------------
# TEST
#------------------------------------------------------------------- 
specs: deps
	find specs -name '*.spec.coffee' | xargs coffee -e 'console.log """define([],#{JSON.stringify process.argv[4..].map (e)->"spec!"+/^specs\/(.*?)\.spec\.coffee/.exec(e)[1]});"""' > spec-runner/GENERATED_all-specs.js

clean: 
	@@rm src/bootstrap.*
