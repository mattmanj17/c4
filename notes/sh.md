
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

## variables

a variable is a named bit of text.  
you set a variable like this: `x=hello`

you retrieve the value of a variable like this: `${x}`

for example, the script:
```sh
x=hello
echo "${x}"
```
prints `hello`.

## quoting

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

## standard streams

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

## redirection operators

- `command > file`

    - the stdout of `command` is written to `file`,  
      not printed to the screen

    - if `file` already exists, overwrite it

    - `echo hello > hello.txt` creates `hello.txt` containing `hello`,  
      followed by a line break

- `command >&2`

    - write the stdout of `command` to stderr

- `command < file`
    - the stdin of `command` comes from `file`,  
      not what you enter on the keyboard

## pipe operator

- `command_a | command_b`
    - the stdout of `command_a` becomes the stdin of `command_b`

## script arguments

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

## exit statuses

when a command (or script run by `sh`) exits,  
it returns a number representing its _'exit status'_.

the simplest examples are the commands `true` and `false`.

both exit immediately without doing anything.  
`true` exits with a 'successful' status.  
`false` exits with an 'unsuccessful' status.

the special variable `${?}` holds the exit status  
of the last command executed.

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

## the `exit` command

`exit` ends the current shell script,   
or ends the current interactive `sh` session,

`exit` can take one argument:  
a number to use as the script's (or session's) exit status.

if the argument is omitted,  
the exit status is that of the last command executed.

## boolean operators

two new `sh` operators

- `command_0 && command_1`

- `command_0 || command_1`

`&&` is pronounced _'and'_.  
`||` is pronounced _'or'_.

> `&&` and `||` chain commands based on   
>  whether the command on the left succeeded

`&&` means "only run the right command if the left one succeeds".  
`||` means "only run the right command if the left one fails".

> if we use the commands `true` and `false` as examples,  
> we see that `&&` and `||` follow the usual patterns of a  
> [_'boolean algebra'_](https://simple.wikipedia.org/wiki/Boolean_algebra)

- `&&`
    - `false && false` behaves like `false`
    - `false && true` behaves like `false`
    - `true && false` behaves like `false`
    - `true && true` behaves like `true`

- `||`
    - `false || false` behaves like `false`
    - `false || true` behaves like `true`
    - `true || false` behaves like `true`
    - `true || true` behaves like `true`

> in normal boolean algebra,   
> `1` means `true` and `0` means `false`.  
> in `sh`, it is reversed.  
> the convention of '`0` means successful exit' is old and strong.  
> so, we have to deal with a bit of confusion.

## `;`

in `sh`, `;` is a _command separator_.  
it lets you put multiple commands on one line.

for example, these two scripts have the same behavior:
- ```sh
  echo hello; echo world
  ```
- ```sh
  echo hello
  echo world
  ```

## the `test` command

a helpful command in `sh` is `test`.

`test` checks whether some condition holds.

`test` is a bit unusual, because you can write it in two ways:

- `test args ...`

- `[ args ... ]`

`[` is really just another form of `test`.  
the only difference is that it expects its  
last argument to be `]`.

these two commands mean the same thing:
- `test "${1}" = hello`
- `[ "${1}" = hello ]`

some examples:

- `[ "${1}" = hello ]`
    - true if `${1}` is the text `hello`
- `[ "${#}" -eq 3 ]`
    - true if exactly 3 arguments were passed
- `[ "${#}" -ne 0 ]`
    - true if any arguments were passed

like other commands,  
test reports its result using exit status
- `0` means the test passed
- non-zero means the test failed

## `if`

one important control-flow construct in `sh` is `if`.

the syntax of `if` is:

```sh
# leading `if` block
if ...; then

    # block
    ...

# zero or more `elif` blocks
elif ...; then

    # block
    ...

# ...
elif ...; then

    # block
    ...

# ...

# zero or one `else` block
else

    # block
    ...

# trailing `fi` to close the `if`
fi
```

or, more succinctly:

```sh
if ...; then
    ...
elif ...; then
    ...
elif ...; then
    ...
else
    ...
fi
```

---

each `...` is a _list_ of _command invocations_.

an individual invocation is basically of the form:
- `cmd arg arg ...`
- optionally followed by `< file` or `> file`.

a _list_ of such invocations consists of individual invocations,  
possibly connected by operators like:

- `|`
- `&&`
- `||`
- `;`

and possibly split across multiple lines.

---

the semantics of `if` are:

- the `if` list is executed.

- if its exit status is zero,  
  the first `then` list is executed.

- otherwise,  
  each `elif` list is executed in turn.
    - if its exit status is zero,  
      the corresponding `then` list is executed,  
      and the `if` command completes.

- otherwise,  
  the `else` list is executed,  
  if present.

---

the exit status of the entire construct is:

- `0`, if:
    - no condition tested true 
    - AND
    - there was no `else` block

- otherwise:
    - the exit status of  
      the last command executed
