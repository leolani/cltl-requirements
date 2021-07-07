#!/bin/bash

if [[ $(make --version | grep 3.81 | wc -l) -gt 0 ]]; then
  echo "make version too low (OS X has outdated GNU tools installed):"
  make --version
  exit 1
fi

makefile=../../../makefile

test_count=0

start_test() {
  echo ""
  echo "Run test '$1'"

  ((test_count++))
}

clean_up() {
  echo ""
  echo "Clean up"

  make -f "$makefile" clean
  rm -rf timestamp leolani mirror
}

fail() {
  echo "TEST FAILED: $1"
  exit 1
}


clean_up


start_test "make build"

make -f "$makefile" build

if [[ $(diff requirements.txt requirements.lock | wc -l) -ne 0 ]]; then
  fail "requirements.lock incorrect"
fi

if [[ $(find mirror -type f | grep simplejson | grep 3.17.2 | wc -l) -ne 1 ]]; then
  fail "mirror does not contain correct package"
fi

if ! [[ -d leolani ]]; then
  fail "leolani not created"
fi


start_test "make build runs only once"

touch timestamp
make -f "$makefile" build

if [[ leolani -nt timestamp ]]; then
  fail "build ran twice (leolain)"
fi

if [[ mirror -nt timestamp ]]; then
  fail "build ran twice (mirror)"
fi

if [[ requirements.lock -nt timestamp ]]; then
  fail "build ran twice (requirements.lock)"
fi

rm timestamp


start_test "make docker"

make -f "$makefile" docker

if [[ ! -f docker.lock ]]; then
  fail "Docker did not run (requirements.lock)"
fi

if [[ ! -f docker.mirror.lock ]]; then
  fail "Docker did not run (requirements.lock)"
fi


start_test "make docker runs only once"

touch timestamp
make -f "$makefile" --debug docker

if [[ docker.lock -nt timestamp ]]; then
  fail "docker target ran twice (docker.lock)"
fi

if [[ docker.mirror.lock -nt timestamp ]]; then
  fail "docker target ran twice (docker.mirror.lock)"
fi

clean_up


start_test "make docker builds mirror only when needed"

make -f "$makefile" docker

touch timestamp
touch leolani/some_file.test

if [[ docker.mirror.lock -nt timestamp ]]; then
  fail "docker target ran twice"
fi

clean_up


start_test "make docker runs after artifact is added"

make -f "$makefile" docker

touch timestamp
touch leolani/some_file.test
make -f "$makefile" docker

if [[ timestamp -nt docker.lock ]]; then
  fail "docker target did not run after adding an artifact"
fi

if [[ docker.mirror.lock -nt timestamp ]]; then
  fail "docker mirror ran twice"
fi

clean_up


start_test "make docker runs after requirements changed"

make -f "$makefile" docker

touch timestamp
touch requirements.lock
make -f "$makefile" docker

if [[ timestamp -nt docker.lock ]]; then
  fail "docker target did not run after updating requirements (docker.lock)"
fi

if [[ timestamp -nt docker.mirror.lock ]]; then
  fail "docker target did not run after updating requirements (docker.mirror.lock)"
fi

clean_up


start_test "make docker creates all targets"

make -f "$makefile" docker

if [[ $(diff requirements.txt requirements.lock | wc -l) -ne 0 ]]; then
  fail "requirements.lock incorrect"
fi

if [[ $(find mirror -type f | grep simplejson | grep 3.17.2 | wc -l) -ne 1 ]]; then
  fail "mirror does not contain correct package"
fi

if ! [[ -d leolani ]]; then
  fail "leolani not created"
fi

if ! [[ -f docker.lock ]]; then
  fail "docker.lock not created"
fi

clean_up


start_test "make clean"

make -f "$makefile" docker
touch leolani/some_file.test

make -f "$makefile" clean

if [[ -f requirements.lock ]]; then
  fail "requirements.lock not cleaned"
fi

if [[ ! -d mirror ]] || [[ -n $(ls -A mirror) ]]; then
  fail "mirror not cleaned"
fi

if [[ ! -d leolani ]] || [[ -n $(ls -A mirror) ]]; then
  fail "leolani not cleaned"
fi

if [[ $(ls | wc -l) -ne 7 ]]; then
  ls
  fail "Clean has left-overs"
fi

clean_up


echo "RAN $test_count TESTS.. OK"