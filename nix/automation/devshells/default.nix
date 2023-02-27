{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {
      name = "Decentralized Data Science";

      imports = [
        inputs.std.std.devshellProfiles.default

        inputs.cells-lab.automation.devshellProfiles.docs

        inputs.cells.kernels.devshellProfiles.default
      ];

      commands = [
        {
          package = inputs.nixpkgs.poetry;
        }
      ];

      nixago =
        [
          cell.nixago.treefmt
          cell.nixago.just
        ]
        ++ l.attrValues inputs.cells.python.nixago;
    };

    doc = {
      name = "Documentation";
      commands = [
        {
          name = "mkQuarto";
          command = ''
            ${l.getExe (
              inputs.desci.quarto.lib.orgToQuarto
              inputs.cells.kernels.packages.jupyenv
            )} "$PRJ_ROOT"/docs/publish/content/posts
          '';
          help = "Build the documentation with quarto";
        }
      ];
      imports = [
        inputs.cells-lab.automation.devshellProfiles.docs
      ];
    };
  }
