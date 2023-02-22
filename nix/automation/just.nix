{
  fmt = {
    description = "Formats all changed source files";
    content = ''
      treefmt $(git diff --name-only --cached)
    '';
  };
  cachix-push = {
    description = "Uploads the build to cachix";
    content = ''
      nix build .\#x86_64-linux.kernels.packages.jupyenv --json | jq -r '.[].outputs | to_entries[].value' | cachix push gtrunsec
    '';
  };
  generator = {
    description = "generating configFiles with devshell";
    content = ''
      nix develop .\#generator -c echo generating configFiles
    '';
  };

  buildJupyenv = {
    description = "generating configFiles with devshell";
    content = ''
      nix build .\#x86_64-linux.kernels.packages.jupyenv.config.build --print-build-logs
    '';
  };
}
