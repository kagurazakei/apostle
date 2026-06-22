## Feature Request: Declarative Patch Support

### Problem Statement
Currently, `tack` supports `fetch` and `fixed` pin types, but there is no built-in way to apply patches to fetched sources. This requires users to either:
1. Fork the repository and pin the fork
2. Maintain a local patched copy using `path:` pins
3. Apply patches at the Nix derivation level

### Proposed Solution
Add declarative patch support similar to `nixtamal`:

```toml
[inputs.my-dep]
url = "github:user/repo"
patches = [
  "patches/fix-build.patch",
  "patches/feature-backport.patch"
]
