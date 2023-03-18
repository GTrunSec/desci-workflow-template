{
  inputs,
  cell,
}: {
  jupyenv2 = inputs.jupyenv.lib.mkJupyterlabEval ({...}: {
    nixpkgs = inputs.nixpkgs.appendOverlays [
      inputs.desci.inputs.julia2nix.overlays.default
    ];
    kernel.python.d = {
      enable = true;
      inherit (inputs.cells.python.lib) nixpkgs;
      withDefaultOverrides = false;
      groups = ["aws"];
      overrides =
        # Do not add poetry2nix.overrides if you have merged other overrides;
        # (nixpkgs.poetry2nix.overrides.withDefaults (import ./packages/overrides.nix))
        #[(import ../python/packages/overrides.nix)]
        import ./overrides.nix inputs.cells.python.lib.nixpkgs.poetry2nix;
    };
  });
  jupyenv =
    inputs.desci.kernels.packages.mkJupyterlabEval
    ({
      pkgs,
      config,
      ...
    }: {
      nixpkgs = inputs.nixpkgs.appendOverlays [
        inputs.desci.inputs.julia2nix.overlays.default
      ];
      imports = [
        (cell.config.resolveKeys pkgs config)
        inputs.desci.kernels.jupyenvModules.quarto
      ];
      kernel.bash.data-science = {
        runtimePackages = [inputs.cells.python.packages.default];
      };
      kernel.julia.data-science = {
        julia = inputs.desci.julia.packages.julia-wrapped;
      };
    });
}
