### directorify
Example configuration key-values. Could be part of `package.json`
```livescript
directorify:
    inputFile:"./dist/foo.js" # !important
    saveFile:"./src.js # !important"
    source:"./src" # default -> process.cwd()
    compile:"./dist" # default -> process.cwd() 
    exclude: ".external.js" # exlcude from bundle 
babelify: # Optional default -> does not run
    presets:['es2015']
```