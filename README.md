# `Vagrantfile` for provisioning Wandbox service

## Usage

#### 1. Update compiler list:
```sh
# provision/build_compilers.sh
main() {
  # ...

  # Install compilers
  do_install clang 3.7.1
  do_install clang-head

  # Install Boost
  do_install boost-head 1.61.0 clang-head
  do_install boost      1.61.0 clang      3.7.1
```

#### 2. Start VM
```sh
$ vagrant up [--provision]
$ curl http://127.0.0.1:3500/api/list.json
```