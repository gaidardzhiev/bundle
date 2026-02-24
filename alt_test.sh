#!/bin/sh

DIR="tests"
ORIG="orig"

[ ! -f prog ] && make

rm -rf "${DIR}" "${ORIG}"

mkdir "${DIR}" "${ORIG}"

cat > "${ORIG}"/test0.expected <<'EOF'
this is test 0
EOF

cat > "${ORIG}"/test1.expected <<'EOF'
this is test 1
EOF

cat > "${ORIG}"/test2.expected <<'EOF'
this is test 2
EOF

cat > "${ORIG}"/test0.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 0");return 0;}
EOF

cat > "${ORIG}"/test1.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 1");return 0;}
EOF

cat > "${ORIG}"/test2.c <<'EOF'
#include<stdio.h>
int main(){puts("this is test 2");return 0;}
EOF

cp "${ORIG}"/*.c "${DIR}"/

cd "${DIR}"

../prog test0.c test1.c test2.c > bundle.sh || exit 1

chmod +x bundle.sh

./bundle.sh || exit 1

fverify() {
	local name="$1" orig_c="$2" expected="$3"
	printf '%-12s' "$name"
	if [ -f "$orig_c" ] && \
		cmp "$orig_c" "../${ORIG}/${orig_c}" >/dev/null 2>&1 && \
		gcc "$orig_c" -o r >/dev/null 2>&1 && \
		./r > r.out 2>/dev/null && \
		cmp r.out "../${ORIG}/${expected}" >/dev/null 2>&1;
	then
		printf 'PASS\n'
	else
		printf 'FAIL\n'
		exit 1
	fi
	rm -f r *.out 2>/dev/null
}

fverify "test 0" test0.c test0.expected
fverify "test 1" test1.c test1.expected
fverify "test 2" test2.c test2.expected

cd ..

printf 'delete all test files? [y/no] '

read WIPE && \
	case $WIPE in
		([yY])
			rm -r "${DIR}" "${ORIG}"
			printf "%s and %s deleted...\n" "${DIR}" "${ORIG}"
			;;
		([nN])
			printf "\n"
			;;
		(*)
			printf "invalid response\n"
			printf "please choose [yes/no] "
			;;
esac
