{
  inputs,
  cell,
}: let
  nixpkgs = inputs.dataflow2nix.prefect.lib.nixpkgs;
in {
  prefect = nixpkgs.python3.withPackages (ps:
    with ps; [
      ((ps.pkgs.prefect.override {
          groups = ["aws"];
          overrides = [(import ./packages/overrides.nix)];
        })
        .overrideAttrs (old: {
          pyproject = cell.nixago.prefectPoetry.configFile;
          poetrylock = ./packages/poetry.lock;
        }))
    ]);
}
