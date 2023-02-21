{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.inputs.xnlib.lib.attrsets) recursiveMerge;
  l = inputs.nixpkgs.lib // builtins;
in {
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
