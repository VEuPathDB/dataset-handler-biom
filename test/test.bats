#!/usr/bin/env bats

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../bin:$PATH"

    rm -rf tmp
    rm -f dataset_ucrisl.108976930@eupathdb.org_*.tgz
}

run_on_file() {

  run exportBiomToEuPathDB "a name" "a summary" "a description" "crisl.108976930@eupathdb.org"              "../lib/xml" "output" "$@"

}

success_ok() {

  test -d tmp
  test -f tmp/meta.json
  test -f tmp/dataset.json
  test -d tmp/datafiles
  test -f tmp/datafiles/uploaded.biom
  test -f tmp/datafiles/metadata.json
  test -f tmp/datafiles/data.tsv
  test $( grep -c "a name" tmp/meta.json ) -gt 0
  test $( grep -c "a summary" tmp/meta.json ) -gt 0
  test $( grep -c "a description" tmp/meta.json ) -gt 0
  test $( grep -c "crisl.108976930@eupathdb.org" tmp/dataset.json ) -gt 0

  test -f dataset_ucrisl.108976930@eupathdb.org_*.tgz

  rm -rf tmp
  rm -f dataset_ucrisl.108976930@eupathdb.org_*.tgz

}

invalid_ok() {

  test ! -d tmp
  test $( grep -c '"error": "unknown"' <<< "$output" ) -eq 0
  test $( grep -c '"error": "user"' <<< "$output" ) -gt 0

}

error_ok() {

  test ! -d tmp
  test $( grep -c '"error": "unknown"' <<< "$output" ) -gt 0
  test $( grep -c '"error": "user"' <<< "$output" ) -eq 0

}

@test "no args errors" {

  run exportBiomToEuPathDB

  error_ok 

}

@test "test.biom good run" {

  cp ./test/data/test.biom ./test.biom
  run_on_file ./test.biom

  success_ok
  rm ./test.biom*
}

@test "bad path means an error, not invalid" {

  run_on_file ./missing.biom

  error_ok
}

@test "bad biom means invalid" {
  
  echo "{}" > ./bad.biom

  run_on_file ./bad.biom

  invalid_ok
  rm ./bad.biom
}

@test "bad biom means invalid 2" {
  
  echo "not even JSON" > ./bad.biom

  run_on_file ./bad.biom

  invalid_ok
  rm ./bad.biom
}

@test "path-to.biom bad URL" {

  echo 'not a URL' > ./test.path-to.biom

  run_on_file ./test.path-to.biom

  invalid_ok 
  rm ./test.path-to.biom
}

@test "path-to.biom bad URL 2" {

  echo 'http://localhost:8080/does-not-exist.biom' > ./test.path-to.biom

  run_on_file ./test.path-to.biom

  invalid_ok 
  rm ./test.path-to.biom
}

@test "path-to.biom good run" {

  echo 'https://raw.githubusercontent.com/biocore/biom-format/master/examples/rich_sparse_otu_table.biom' > ./test.path-to.biom

  run_on_file ./test.path-to.biom

  success_ok
  rm ./test.path-to.biom*
}
