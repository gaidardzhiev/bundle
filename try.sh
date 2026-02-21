#!/bin/sh
# create all the files on the fly and mkdir test directory

[ ! -f prog ] && make

mkdir -p testdir
cp file1 file2 file3 testdir/
cp file1 file2 file3 testdir.orig/ 2>/dev/null || mkdir -p testdir.orig && cp file1 file2 file3 testdir.orig/

cd testdir

echo "TESTING BUNDLE"
../prog file1 file2 file3 > bundle.sh || { echo "BUNDLE FAILED"; exit 1; }

echo "TESTING EXTRACTION"
chmod +x bundle.sh
./bundle.sh || { echo "EXTRACTION FAILED"; exit 1; }

echo "COMPARING FILES"
PASSED=1
for f in file1 file2 file3; do
    if ! cmp "$f" "../testdir.orig/$f" >/dev/null 2>&1; then
        echo "$f DIFFERS"
        PASSED=0
    fi
done

if [ $PASSED = 1 ]; then
    echo "ALL FILES MATCH ORIGINALS"
    echo "ALL TESTS PASSED"
else
    echo "VERIFICATION FAILED"
    exit 1
fi

echo "CLEANUP"
cd ..
rm -rf testdir
