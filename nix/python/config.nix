{
  inputs,
  cell,
}: let
  inherit (inputs) self std;
  inherit (inputs.cells-lab.inputs.xnlib.lib.attrsets) recursiveMerge;
  l = inputs.nixpkgs.lib // builtins;

  nixpkgs = inputs.dataflow2nix.prefect.lib.nixpkgs;
in {
  poetryEnvArgs = {
    poetrylock = (std.incl self ["poetry.lock"]) + "/poetry.lock";
    pyproject = cell.nixago.pyproject.configFile;
    preferWheels = true;
    overrides =
      # Do not add poetry2nix.overrides if you have merged other overrides;
      # (nixpkgs.poetry2nix.overrides.withDefaults (import ./packages/overrides.nix))
      [(import ./packages/overrides.nix)]
      ++ cell.config.poetry.overrides
      ++ (import "${inputs.dataflow2nix}/nix/prefect/packages/overrides.nix" nixpkgs.poetry2nix);
  };

  poetry =
    l.recursiveUpdate (cell.lib.mergePoetryEnv [
      {
        path = ./packages;
      }
      {
        path = "${inputs.dataflow2nix}/nix/prefect/packages";
        overrides = false;
      }
      {path = "${inputs.desci}/nix/python/packages";}
    ]) {
      pyproject = {
        # tool.poetry.dependencies.polars = {
        #   version = "^0.15.1";
        #   format = "wheel";
        # };
      };
    };
}
