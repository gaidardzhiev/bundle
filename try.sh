#!/bin/sh

TEST="tests"
ORIG="originals"

[ ! -f prog ] && { make || exit 1; }

printf "cleaning previous runs\n"
rm -rf "${TEST}" "${ORIG}"

printf "building original test files and expectations\n"
printf "creating workspaces: %s/ and %s/\n" "${TEST}" "${ORIG}"
mkdir "${TEST}" "${ORIG}"

printf "generating 3 original C programs and expected outputs in %s/\n\n" "${ORIG}"

cat > "${ORIG}"/test0.expected <<'EOF'
this is test 0
EOF
printf "  test0.expected created\n"

cat > "${ORIG}"/test1.expected <<'EOF'
this is test 1
EOF
printf "  test1.expected created\n"

cat > "${ORIG}"/test2.expected <<'EOF'
this is test 2
EOF
printf "  test2.expected created\n"

cat > "${ORIG}"/test0.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 0");return 0;}
EOF
printf "  test0.c created\n"

cat > "${ORIG}"/test1.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 1");return 0;}
EOF
printf "  test1.c created\n"

cat > "${ORIG}"/test2.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 2");return 0;}
EOF
printf "  test2.c created\n"

printf "\ncopying sources to test dir: %s/\n" "${TEST}"
cp "${ORIG}"/*.c "${TEST}"/

printf "\nCORE TEST: generating the self extracting bundle\n"
cd "${TEST}"
../prog test0.c test1.c test2.c > bundle.sh || {
	printf "bundle generation FAILED\n";
	exit 2;
}
printf "  bundle.sh created (the self extracting archive)\n"

(set -x; rm -f *.c; set +x) 2>&1 | grep rm
printf "  source files removed, now testing pure rebundle fidelity\n"

chmod +x bundle.sh
printf "executing bundle.sh and recreating files exactly\n"
./bundle.sh || {
	printf "bundle extraction FAILED\n";
	exit 3;
}
printf "  files recreated by bundle.sh:\n"
(set -x; ls -la *.c; set +x) 2>&1 | grep ls

printf "\nverifying byte for byte fidelity and proper compilation\n"

fverify() {
	local NAME="${1}" ORIG_C="${2}" EXPECTED="${3}"
	printf '%-12s' "${NAME}"
	{ [ -f "${ORIG_C}" ] && \
		cmp "${ORIG_C}" "../${ORIG}/${ORIG_C}" >/dev/null 2>&1 && \
		gcc "${ORIG_C}" -o r >/dev/null 2>&1 && \
		./r > r.out 2>/dev/null && \
		cmp r.out "../${ORIG}/${EXPECTED}" >/dev/null 2>&1; \
	} && printf 'PASS\n' || {
		printf 'FAIL\n';
		exit 4;
	}
	rm -f r *.out 2>/dev/null
}

fverify "test 0" test0.c test0.expected
fverify "test 1" test1.c test1.expected
fverify "test 2" test2.c test2.expected

cd ..
printf "\nALL TESTS PASS: bundle.sh perfectly recreates and recompiles originals\n"

printf "\nkeep all files for manual inspection?\n[y/n]: "
read -r WIPE
case $WIPE in
	[nN]* )
		rm -rf "${TEST}" "${ORIG}";
		printf "  %s/ and %s/ deleted\n" "${TEST}" "${ORIG}"
		;;
	[yY]* )
		printf "  keeping %s/ and %s/ for inspection\n" "${TEST}" "${ORIG}"
		;;
	* )
		printf "  keeping files? (choose y/n)\n"
		;;
esac

printf "\nTEST COMPLETED\n"
