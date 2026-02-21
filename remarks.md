Remarks on the Obfuscated Bundle Generator

What it does
- Takes file arguments and emits a self extracting shell script (`#!/bin/sh`) that recreates those files with original contents.
- If run without arguments, prints a short usage string and replays the second line of its own source shebang (mirrors the original helper behavior).
- Keeps all file data inline; the generated script can be executed to restore files exactly as provided.

Obfuscation layers (applied cumulatively)
- Identifier mutation: Every function, variable, and macro name is meaningless junk; `main` is now a trampoline into `m0xF1aB`.
- Encrypted strings: All human readable text is XORed with a key; the key and ciphertexts themselves are stored base64 encoded after a rotate right by 3 on each byte, then decoded and decrypted once at startup.
- Control flow flattening: The entire program runs as a single `switch` driven state machine loop; conventional `if`/`while` logic is replaced with explicit state transitions plus opaque predicates to obscure reachability.
- Data obfuscation: Buffer sizes are defined via bit soup macros; constants are assembled from split bitfields. A hidden, unreachable state writes an “ioccc 2026” signature as an Easter egg.
- Macro layer: Macros wrap flow keywords (`LOOP`, `SWITCH`, `CASE`, `NEXT`, `RET`) and inject a red-herring XOR macro (`A/B`) plus unused predicate scaffolding (`Z`, `W`, `PRED`) to complicate static reading.

Runtime flow (human view)
1) One time decode step rebuilds key and message tables, rotates them back, then XOR decrypts to get usable strings.
2) State machine path:
   - States 0–3: argument count check, usage print, optional self shebang replay, exit.
   - States 4–13: emit shell header, iterate inputs, emit here doc wrappers, stream file bytes, close docs; missing files trigger a decrypted warning; hidden state 13 can print the Easter egg before termination.

Testing and fidelity
- Verified repeatedly with `make clean`, `make`, and `./verify.sh`; the bundle reproduces `file1`, `file2`, `file3` byte for byte against originals.
