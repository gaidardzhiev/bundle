### BUNDLE
This program reads one or more files from the command line and emits a self extracting POSIX shell script that, when executed, reconstructs the input files with their original contents intact.
It functions as a bundle generator, embedding file contents within executable archives that restore originals upon execution.

### Obfuscation layers (applied cumulatively)
- Identifier mutation: Every function, variable, and macro name is meaningless junk; `main` is now a trampoline into `m0xF1aB`.
- Encrypted strings: All human readable text is XORed with a key; the key and ciphertexts themselves are stored base64 encoded after a rotate right by 3 on each byte, then decoded and decrypted once at startup.
- Control flow flattening: The entire program runs as a single `switch` driven state machine loop; conventional `if`/`while` logic is replaced with explicit state transitions plus opaque predicates to obscure reachability.
- Data obfuscation: Buffer sizes are defined via bit soup macros; constants are assembled from split bitfields. A hidden, unreachable state writes an “ioccc 2026” signature as an Easter egg.
- Macro layer: Macros wrap flow keywords (`LOOP`, `SWITCH`, `CASE`, `NEXT`, `RET`) and inject a red-herring XOR macro (`A/B`) plus unused predicate scaffolding (`Z`, `W`, `PRED`) to complicate static reading.

Runtime flow:
1) One time decode step rebuilds key and message tables, rotates them back, then XOR decrypts to get usable strings.
2) State machine path:
   - States 0–3: argument count check, usage print, optional self shebang replay, exit.
   - States 4–13: emit shell header, iterate inputs, emit here doc wrappers, stream file bytes, close docs; missing files trigger a decrypted warning; hidden state 13 can print the Easter egg before termination.

### Testing
- Verify with `make clobber`, `make`, and `./try.sh` or just manualy; the bundle reproduces the files byte for byte against originals.
