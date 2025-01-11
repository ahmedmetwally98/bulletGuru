# Compiler and flags
CC = gcc
CFLAGS = -Wall -std=c11

# Source and executable
SRC = fork_proc.c
EXE = fork_no_wait

# Default target
all: $(EXE)

# Rule to build the executable
$(EXE): $(SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Rule to run the program normally
run:
	@echo "Running the program normally:"
	./$(EXE)

# Rule to run and display process status
run-status: $(EXE)
	@echo "Running the program and displaying process status:"
	./$(EXE) &
	sleep 1
	ps -l

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(EXE)