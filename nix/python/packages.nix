{
  inputs,
  cell,
}: let
  inherit (inputs) std self;

  l = inputs.nixpkgs.lib // builtins;
  nixpkgs = inputs.nixpkgs.appendOverlays [
    inputs.desci.inputs.jupyenv.inputs.poetry2nix.overlay
  ];
in {
  a = l.makeOverridable ({groups ? "d", ...} @ attrs:
    nixpkgs.poetry2nix.mkPoetryEnv (cell.config.poetryEnvArgs
      // attrs)) {};

  # b = a.override {
  #   groups = ["jupyenv"];
  # };

  default = nixpkgs.poetry2nix.mkPoetryEnv (
    cell.config.poetryEnvArgs
    // {
      extraPackages = ps: [
        ps.python-lsp-server
        ps.python-lsp-server.passthru.optional-dependencies.all
      ];
      groups = ["prefect" "aws" "data"];
    }
  );
}
