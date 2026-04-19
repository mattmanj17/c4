
# make

- lines starting with `#` are comments
    - just there for you to read
    - ignored as if they were blank lines

- a simple makefile is a list of targets
    - a target looks like  
        > _name_ : _deps_  
        > &nbsp; _recipe_
    - where:
        - _name_ is the name of the target
        - _deps_ is a list of dependencies
        - _recipe_ is a list of shell commands
            > each line of the recipe must start with a tab ('\t').

- if you invoke make with no arguments (`make`)  
  it tries to make the first target in the  
  _default makefile_ in the current directory

- GNU make searches for the default makefile in this order:
    - GNUmakefile
    - makefile
    - Makefile

- to make a target _T_ :
    - for each dependency _D_,  
      if it names a target,  
      make that target
    - decide if _T_ is out of date.   
      it is considered out of date in the following cases:
        - a file named _T_ does not exist
        - _T_ is listed as a __phony target__
        - there is a dependency _D_ such that,  
          a file named _D_ exists,  
          and the file _T_ is older than the file _D_
        - a dependency _D_ is listed as a __phony target__
    - if _T_ is out of date,  
      run its recipe.
        - each recipe line is run in its own instance of `sh`

- you can do `make <target>` to make a specific target



