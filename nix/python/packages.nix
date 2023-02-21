{
  inputs,
  cell,
}: let
  inherit (inputs) std self;

  nixpkgs = inputs.dataflow2nix.prefect.lib.nixpkgs;
in {
  default = nixpkgs.poetry2nix.mkPoetryEnv {
    poetrylock = (std.incl self [ "poetry.lock"]) + "/poetry.lock";
    pyproject = cell.nixago.pyproject.configFile;
    groups = ["aws" "jupyenv" "data"];
    preferWheels = true;
    overrides =
      # Do not add poetry2nix.overrides if you have merged other overrides;
      # (nixpkgs.poetry2nix.overrides.withDefaults (import ./packages/overrides.nix))
      [ (import ./packages/overrides.nix) ]
      ++ cell.config.poetry.overrides ++ (import "${inputs.dataflow2nix}/nix/prefect/packages/overrides.nix" nixpkgs.poetry2nix);
  };
}
