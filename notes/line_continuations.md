
# line continuations

- a common pattern in _'line oriented'_ languages  
  _(that is, languages where line breaks have semantic meaning)_  
  is to provide a way to combine multiple _'physical'_ lines  
  into one _'logical'_ line
    - this allows very long logical lines to be split into  
      multiple physical lines

- This is commonly done by putting a `\` at the end of a  
  physical line.

- for example, these physical lines ...
    ```
    this is one \
    long logical line, \
    but 3 physical lines.
    ```
  are equivalent to the logical line ...
    ```
    this is one long logical line, but 3 physical lines.
    ```

- `\` must be the last character on the physical line  
  (it must be immediately be followed by `"\n"`)