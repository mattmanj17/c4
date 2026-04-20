
# sh

`sh` is a program that runs _'commands'_

- it can be used interactively
- or it can run scripts: `sh ./script.sh`

usually, a line starting with `#` is a comment

- just there for you to read
- ignored as if they were blank lines

for each non-blank line of input:

- `sh` splits the line into _'words'_

- the first word names a command to run, and the  
  remaining words are passed to that command as arguments

for example, if you were in an interactive `sh` session,  
and you enter `echo hello world` on the keyboard,  
you would see `hello world` printed to the screen.

### variables

a variable is a named bit of text.  
you set a variable like this: `x=hello`

you retrieve the value of a variable like this: `${x}`

for example, the script:
```sh
x=hello
echo "${x}"
```
prints `hello`.

### quoting

quotes help decide where words start and end

- for example `echo hello world` is 3 words:
    - `echo`
    - `hello`
    - `world`

- while `echo "hello world"` is 2 words:
    - `echo`
    - `hello world`

two common kinds of quotes:

- single quotes: `'...'`
- double quotes: `"..."`

> both `'...'` and `"..."` prevent spaces from splitting words

inside `'...'`, almost everything is treated literally

- the only special character is `'`, which ends the quote

- the script:
  ```sh
  x=hello
  echo '${x}'
  ```
  would print `${x}`, even though `${x}`  
  normally expands to the value of `x`

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

unlike `'...'`, inside `"..."`:
- `'` is no longer a special character
    - `"'"` just means `'`
- variables are expanded
    - the script
      ```sh
      x=hello
      echo "${x}"
      ```
      prints `hello`

### standard streams

commands usually have three standard streams:

- standard input, to read generic input data
- standard output, to write normal output
- standard error, to write error messages

more commonly called:

- stdin
- stdout
- stderr

by default, in an interactive `sh` session:

- stdin is what you enter on the keyboard
- stdout and stderr are printed to the screen

### redirection operators

- `command > file`

    - the stdout of `command` is written to `file`,  
      not printed to the screen

    - if `file` already exists, overwrite it

    - `echo hello > hello.txt` creates `hello.txt` containing `hello`,  
      followed by a line break

- `command < file`
    - the stdin of `command` comes from `file`,  
      not what you enter on the keyboard

### pipe operator

- `command_a | command_b`
    - the stdout of `command_a` becomes the stdin of `command_b`

### script arguments

inside of a script, you get access to some special variables:

- `${0}` : the name of the script file
- `${1}` : the first argument passed to the script
- `${n}` : the `n`th argument, for n >= 1
- `${#}` : the count of arguments passed to the script

some example scripts

- ```sh
  # name.sh
  echo "my name is ${0}"
  ```
  `sh name.sh` would print `my name is name.sh`

- ```sh
  # dup.sh
  echo "${1} ${1}"
  ```
  `sh dup.sh a` would print `a a`

- ```sh
  # flip.sh
  echo "${2} ${1}"
  ```
  `sh flip.sh a b` would print `b a`

- ```sh
  # count.sh
  echo "${#}"
  ```
  `sh count.sh a a a` would print `3`

### exit statuses

when a command (or script run by `sh`) exits,  
it returns a number representing its _'exit status'_.

the simplest examples are the commands `true` and `false`.

both exit immediately without doing anything.  
`true` exits with a 'successful' status.  
`false` exits with an 'unsuccessful' status.

the special variable `${?}` holds the exit status  
of the most recently executed command.

by convention, the 'successful status' number is `0`.  
commands use non-zero exit codes to signal arbitrary information,    
most commonly errors.

- this script
  ```sh
  true
  echo "${?}"
  ```
  should print `0`

- this script
  ```sh
  false
  echo "${?}"
  ```
  should print `1`
