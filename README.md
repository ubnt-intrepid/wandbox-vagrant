# `Vagrantfile` for provisioning Wandbox service

## Usage

#### 1. Update compiler list:
```sh
# provision/build_wandbox.sh

declare -a targets=(
  "clang-head"
  "ocaml-head"
  "pony-head"
  "gcc-head"
)
```
Currently, only HEADs are supported.

#### 2. Start VM
```sh
$ vagrant up [--provision]
$ curl http://127.0.0.1:3500/api/list.json
```

## TODO
- [ ] Modify `compilers.py`
  - Choose installed compilers from config file
  - Remove uninstalled compilers from `compilers.default`
- [x] ~~Write Dockerfile~~
  - ~~Use `supervisord`~~
