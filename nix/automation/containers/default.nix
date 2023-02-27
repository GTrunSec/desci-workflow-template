{
  inputs,
  cell,
}: let
  inherit (inputs) std;
in {
  dev = std.lib.ops.mkDevOCI {
    name = "ghcr.io/gtrunsec/workflow-template.default";
    tag = "latest";
    devshell = cell.devshells.default;
    labels = {
      title = "workflow-template.default";
      version = "latest";
      url = "https://gtrunsec.github.io/workflow-template";
      source = "https://github.com/gtrunsec/workflow-template/nix/automation";
      description = ''
        A prepackaged container for running desci workflows.
      '';
    };
  };
}
