{
  inputs = {
    nixpkgs.follows = "desci/nixpkgs";
    # desci.url = "/home/guangtao/ghq/github.com/GTrunSec/DeSci";
    desci.url = "github:GTrunSec/DeSci";
    # desci.inputs.jupyenv.follows = "jupyenv";
    cells-lab.follows = "desci/cells-lab";
    std.follows = "desci/std";
    xnlib.url = "/home/guangtao/ghq/github.com/GTrunSec/xnlib";
    std-data-collection.follows = "desci/std-data-collection";
    dataflow2nix.follows = "desci/dataflow2nix";
    # jupyenv.url = "github:tweag/jupyenv?ref=pull/437/head";
    # dataflow2nix.url = "/home/guangtao/ghq/github.com/GTrunSec/dataflow2nix";
  };

  outputs = {
    std,
    self,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (functions "devshellProfiles")

        (devshells "devshells")

        (runnables "entrypoints")

        (functions "lib")
        (functions "config")

        (containers "containers")

        (installables "packages" {ci.build = true;})

        (nixago "nixago")
      ];
    } {
      devShells = inputs.std.harvest inputs.self ["automation" "devshells"];
    } {
      process-compose =
        inputs.cells-lab.lib.mkProcessCompose ["composeJobs" "oci-images"]
        self {
          log_location = "$HOME/.cache/process-compose.log";
        };
    } {
      # template
    };
  nixConfig = {
    extra-substituters = [
      "https://gtrunsec.cachix.org"
    ];
    extra-trusted-public-keys = [
      "gtrunsec.cachix.org-1:hqyEeSuO8HAm6xuChKrTJpLPpHUKtdjh4o/MRmcMQIo="
    ];
  };
}
