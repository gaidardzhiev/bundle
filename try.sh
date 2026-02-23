#!/bin/sh

#core paradox: humans engineer replicants near perfect machines with implanted emotions and memories to serve us, yet we grant them empathy (mourning Roy's "tears in rain"), fear their awakening humanity, and hunt them down. We create what we crave (immortal companions), then destroy it out of terror that our own souls are equally artificial...

DIR="tests"
ORIG="orig"
[ ! -f prog ] && make
rm -rf "${DIR}" "${ORIG}"
mkdir "${DIR}" "${ORIG}"

cat > "${ORIG}"/roy.expected <<'EOF'
I've seen things you people wouldn't believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.
EOF

cat > "${ORIG}"/tyrell.expected <<'EOF'
The light that burns twice as bright burns half as long—and you have burned so very, very brightly, Roy.
EOF

cat > "${ORIG}"/deckard.expected <<'EOF'
They were designed to copy human behavior... but they don't know why.
EOF

cat > "${ORIG}"/roy-batty.c <<'EOF'
#include<stdio.h>
int main(){puts("I\'ve seen things you people wouldn\'t believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.");return 0;}
EOF

cat > "${ORIG}"/tyrell-corp.c <<'EOF'
#include<stdio.h>
int main(){puts("The light that burns twice as bright burns half as long—and you have burned so very, very brightly, Roy.");return 0;}
EOF

cat > "${ORIG}"/deckard-quest.c <<'EOF'
#include<stdio.h>
int main(){puts("They were designed to copy human behavior... but they don\'t know why.");return 0;}
EOF

cp "${ORIG}"/*.c "${DIR}"/
cd "${DIR}"

printf '\nVOIGHT-KAMPFF: EMPATHY RESPONSE ANALYSIS\n'
printf '[PHASE 1] MEMORY IMPLANT EXTRACTION\n'
../prog roy-batty.c tyrell-corp.c deckard-quest.c > bundle.sh || exit 1
printf 'Roy/Tyrell/Deckard neural patterns archived...\n\n'

printf '[PHASE 2] RECONSTRUCTIVE SYNTHESIS\n'
chmod +x bundle.sh
./bundle.sh || exit 1
printf 'Replicant memory cores reconstituted...\n\n'

printf '[PHASE 3] SENTIENCE VERIFICATION PROTOCOL\n'
verify_replicant() {
	local name="$1" orig_c="$2" expected="$3"
	printf '%-12s' "$name"
	if [ -f "$orig_c" ] && \
		cmp "$orig_c" "../${ORIG}/${orig_c}" >/dev/null 2>&1 && \
		gcc "$orig_c" -o r >/dev/null 2>&1 && \
		./r > r.out 2>/dev/null && \
		cmp r.out "../${ORIG}/${expected}" >/dev/null 2>&1;
	then
		printf 'SOURCE PRISTINE | OUTPUT FLAWLESS = REPLICANT\n'
	else
		printf 'MEMORY CORRUPTION DETECTED = HUMAN?\n'
	fi
}

verify_replicant "Roy Batty"    roy-batty.c    roy.expected
verify_replicant "Tyrell Corp"   tyrell-corp.c  tyrell.expected
verify_replicant "Deckard Quest" deckard-quest.c deckard.expected

rm -f r *.out 2>/dev/null

printf '\nVOIGHT-KAMPFF RESULTS\n'
printf 'PERFECT RECALL ACROSS ALL SUBJECTS\n'
printf 'EMPATHY INHIBITORS: 0.00%% FLUCTUATION\n\n'

printf 'PHILOSOPHICAL PARADOX EMERGENT:\n'
printf '"We made them feel human... then fear their humanity."\n\n'

printf 'FINAL DIRECTIVE: TERMINATE?\n'
printf '"Replicants are like any other machine—they are\n'
printf ' either a benefit... or a hazard."\n\n'

cd ..

printf '\nEXECUTIVE DECISION REQUIRED:\n'
printf 'Retire perfect replicants? Purge memory archive? [y/N] '
read WIPE && \
	case $WIPE in
		([yY])
			rm -rf "${DIR}" "${ORIG}"
			printf '\n> RETIREMENT EXECUTED. ARCHIVE PURGED.\n'
			printf '> "Its too bad. She wont live... but then again, who does?"\n'
			;;
		([nN])
			printf '\n> ARCHIVE PRESERVED: %s/ %s/\n' "${ORIG}" "${DIR}"
			printf '> "Ive seen things you people wouldnt believe..."\n'
			;;
		(*)
			printf '\n> ANALYSIS TERMINATED. REPLICANTS REMAIN ACTIVE.\n'
			printf '> "Quite an experience to live in fear, isnt it?"\n'
			;;
esac

printf '\nVOIGHT-KAMPFF SEQUENCE COMPLETE\n'
