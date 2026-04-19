
# sh

- `sh` is a program that runs commands

    - it can be used interactivly
    - or it can run a script: `sh <script>`

- lines starting with `#` are comments

    - just there for you to read
    - ignored as if they were blank lines

- each non-blank line passed to `sh` _'calls a command'_

    - the line is broken up into _'words'_
        
        - some kinds of words:
            - __quotes__
            - consecutive non-whitespace characters
        - for example `echo hello world` is 3 words
            - `echo`
            - `hello`
            - `world`
        - while `echo "hello world"` is two words
            - `echo`
            - `hello world`

    - the first word names a command to run, and the  
      remaining words are passed to that command as arguments 

    - for example, if you were in an iteractive `sh` session,  
      and you typed `echo "hello world"`, you would see `hello world`  
      'echo-ed' back to you (written on the screen)

### variables

- a variable is a named bit of text
- you retrieve the value of a variable using `$`
- for example, `x=hello` `echo $x` would print `hello` 

### quoting

- quotes let us put spaces (_and other special characters_) inside words

- some kinds of quotes:
    - single quotes: `'...'`
    - double quotes: `"..."`

- both `'...'` and `"..."` prevent spaces from splitting words

- inside `'...'`, almost everything is treated literally

    - the only special character is `'`, which ends the quote

    - so, `x=hello` `echo '$x'` would print `$x`,  
      even though it would normaly expand to `hello`

    - to put a `'` in a `'...'`, you do `'...'\''...'`
        - that is, to single quote `a 'b' c`,  
          you would write `'a '\''b'\'' c'`
        > there are two ways to think about this
        > 
        > one, putting `'\''` inside `'...'` is  
        > "just how you put a `'` in a `'...'`"
        >
        > or, using `a 'b' c` as an example again,  
        > the 5 bits `'a '`, `\'`, `'b'`, `\'`, `' c'`  
        > get joined back together to form `a 'b' c`

- unlike `'...'`, inside of `"..."` :
    - `'` is no longer a special character
        - `"'"` just means `'`
    - variables are expanded 
        - `x=hello` `echo "$x"` prints `hello`
        
### redirection operators

- `command > file`
    - redirect the output of `command` to the file `file`
    - if `file` already exists, overwrite it
    - `echo hello > hello.txt` creates `hello.txt` containing `"hello\n"`

- `command < file`
    - `command` reads from `file` instead of the terminal

### pipe operator

- `command_1 | command_0`
    - `command_1` reads the output of `command_0`,  
    instead of from the terminal
