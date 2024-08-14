{
  description = "Dev shell for ansible.";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    allSystems = [
      "x86_64-linux" # 64bit AMD/Intel x86
      "aarch64-darwin" # 64bit ARM macOS
    ];
    forAllSystems = fn:
      nixpkgs.lib.genAttrs allSystems
      (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        name = "ansible-nixos-deploy";
        nativeBuildInputs = with pkgs; [ansible python3];
      };
    });
  };
}
