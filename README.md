# Haskell Brainfuck Interpreter

This is a Brainfuck interpreter written in Haskell using Parsec for parsing and the State monad for running the program. The cells are unsigned 8-bit ints (represented using Word8).

# Usage
To run on an input file, run this:
```
cabal run BrainfuckInterpreter INPUT
```
```,``` takes input from ```STDIN```. For example, if you have a file ```secrets.txt``` you want to encode/decode using the ROT13 cipher program provided here in rot13.txt, you can run
```
cat secrets.txt | cabal run BrainfuckInterpreter rot13.txt
```
