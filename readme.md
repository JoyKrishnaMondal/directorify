### directorify - Directory based bundling using browserify

browserify is a powerful tool to write modern javascript on the browser. 

However, bundling using browserify can get slow - really **slow**. 

The solution around this is to separate your *external* dependencies from the script files you are currently working on.

Building software in this fashion is extremely powerful - since any error can be trivially tracked using dev tool.

This tool is fairly general  but its signature  usecage is when you are using bleeding ege versions of compilers targeting javascript - typescript, babel, livescript, etc.

Example configuration key-values. Could be part of `package.json`
```livescript
directorify:
    inputFile:"./dist/foo.js" # !important
    saveFile:"./src.js" # !important
    source:"./src" # default -> process.cwd()
    compile:"./dist" # default -> process.cwd() 
    exclude: ".external.js" # exlcude from bundle 
babelify: # Optional default -> does not run
    presets:['es2015']
```
