# `Vagrantfile` for provisioning Wandbox service

## Usage
* Update compiler list:
  ```sh
  // provision/build_wandbox.sh
  ...
  declare -a targets=(
    "go-head"
    "ocaml-head"
    "pony-head"
    "gcc-head"
  )
  ```
  Currently, only HEADs are supported.

* Fix compilers.py:
  ```py
  class Switches(object):
      ...
      def make(self):
          return merge(
              ...
              self.make_cxx(),
          )
  ...
  class Compilers(object):
      ...
      def make(self):
        ...
  ```

* Start VM
  ```sh
  $ vagrant up [--provision]
  $ curl http://127.0.0.1:3500/api/list.json
  ```

## TODO
- [ ] Modify `compilers.py`
  - Choose installed compilers from config file
  - Remove uninstalled compilers from `compilers.default`
- [x] Write Dockerfile
  - Use `supervisord`
