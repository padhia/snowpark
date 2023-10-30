{
  description = "Python Snowpark development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    sfconn-git = {
      url = "github:padhia/sfconn";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, sfconn-git }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system};

      let
        python = python311;
        callPackage = lib.callPackageWith (nixpkgs // python.pkgs // myPkgs);

        myPkgs = {
          snowflake-connector-python = callPackage ./snowflake-connector-python.nix {};
          snowpark = callPackage ./snowpark.nix {};
          sfconn = callPackage "${sfconn-git}/sfconn.nix" {};
        };

        pyPkgs = p: with p; [
          pip
          setuptools
          wheel
          build
          pytest
          mypy
          flake8
          black
          myPkgs.sfconn
          myPkgs.snowpark
        ];

        defaultPackage = python.withPackages pyPkgs;

        devShell = mkShell {
          name = "snowpark";
          buildInputs = [ python ruff ] ++ (pyPkgs python.pkgs);
        };

      in
      {
        inherit devShell defaultPackage;
      }
    );
}
