{
  inputs,
  cell,
}: let
  inherit (inputs.std-ext.writers.lib) writeShellApplication;
  inherit (inputs) self std nixpkgs;
in {
  mkdoc = inputs.desci.automation.lib.orgToHugo "${(std.incl self ["docs"])}/docs/org";

  auto-commit-infra = cell.lib.mkAutoCommit "infra" "origin HEAD:DeSci";
}
