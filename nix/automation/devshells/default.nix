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
      ];

      commands = [
        {
          package = inputs.nixpkgs.poetry;
        }
      ];

      nixago = [
        cell.nixago.treefmt
        cell.nixago.just
      ];
    };

    doc = {
      name = "Documentation";
      commands = [
        {
          name = "mkQuarto";
          command = ''
            ${l.getExe inputs.desci.quarto.entrypoints.orgToQuarto} "$PRJ_ROOT"/docs/publish/content/posts
          '';
          help = "Build the documentation with quarto";
        }
      ];
      imports = [
        inputs.cells-lab.automation.devshellProfiles.docs
      ];
    };
  }
