# fixed output derivation adapted from
# https://github.com/NixOS/nixpkgs/blob/28c3f83a9a77e3ada57afb71cc4052d2c435597a/pkgs/by-name/op/opencode/package.nix#L59-L122
{
  lib,
  stdenvNoCC,
  bun,
  writableTmpDirAsHomeHook,
  sources,
}:
let
  equibop = sources.equibop;

  # equibop is a string path from .tack - use it directly
  srcPath = equibop; # No hasAttr checks needed

  version = "nightly";
in
stdenvNoCC.mkDerivation {
  name = "equibop-modules-${version}";
  src = srcPath;
  inherit version;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND"
    "SOCKS_SERVER"
  ];

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  dontConfigure = true;
  dontFixup = true;

  buildPhase = ''
    runHook preBuild

    export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

    bun install \
        --filter=equibop \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --linker=hoisted \
        --no-progress

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ./node_modules $out

    runHook postInstall
  '';

  outputHash =
    {
      x86_64-linux = "sha256-dLATw5Mb9grQnI/JTdlRdNP2JETELeqY8aXqb5dCXOA=";
      aarch64-linux = "sha256-UsccQFaSSjhmv1+oF2FZcRG8xtWBCcPD+tizbdQ7SSI=";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
