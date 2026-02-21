CC=gcc
BIN=prog

all: $(BIN)

prog:
	gcc prog.c -o $(BIN)

clean:
	rm -f $(BIN)
