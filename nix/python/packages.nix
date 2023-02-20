{
  inputs,
  cell,
}: let
  nixpkgs = inputs.dataflow2nix.prefect.lib.nixpkgs;
in {
  # prefect = nixpkgs.python3.withPackages (ps:
  #   with ps; [
  #     ((ps.pkgs.prefect.override {
  #         overrides = [(import ./packages/overrides.nix)];
  #       })
  #       .overrideAttrs (old: {
  #         groups = ["aws"];
  #         pyproject = cell.nixago.prefectPoetry.configFile;
  #         poetrylock = ./packages/poetry.lock;
  #       }))
  #   ]);

  # test = (nixpkgs.prefect.override ({
  #   overrides = [(import ./packages/overrides.nix)];
  #   groups = ["aws"];
  # })).overrideDerivation (old: {
  #   pyproject = cell.nixago.prefectPoetry.configFile;
  #   poetrylock = ./packages/poetry.lock;
  # });
  #
  default = nixpkgs.poetry2nix.mkPoetryEnv {
    poetrylock = ./packages/poetry.lock;
    pyproject = cell.nixago.pyproject.configFile;
    groups = ["aws" "jupyenv"];
    preferWheels = true;
    overrides =
      # Do not add poetry2nix.overrides if you have merged other overrides;
      # (nixpkgs.poetry2nix.overrides.withDefaults (import ./packages/overrides.nix))
      [ (import ./packages/overrides.nix) ]
      ++ cell.config.poetry.overrides ++ (import "${inputs.dataflow2nix}/nix/prefect/packages/overrides.nix" nixpkgs.poetry2nix);
  };
}
