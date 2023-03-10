{
  inputs,
  cell,
}: let
  inherit (inputs) std self;
  nixpkgs = inputs.nixpkgs.appendOverlays [
    inputs.desci.inputs.jupyenv.inputs.poetry2nix.overlay
  ];
in {
  default = nixpkgs.poetry2nix.mkPoetryEnv (
    cell.config.poetryEnvArgs
    // {
      groups = ["prefect" "jupyter" "aws" "jupyenv" "data"];
    }
  );
}
