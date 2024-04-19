{
  # multiStdenv,
  stdenv,
  fetchFromGitHub,
  zlib,
  libGL,
  SDL2,
  pkg-config,
  git,
  python3,
  ...
}:
stdenv.mkDerivation rec {
  pname = "perfect-dark";
  version = "b4f7f467c05bc2e446fff46c6d7fc195d0283f55";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    rev = version;
    hash = "sha256-UZUuFmNr8WehqgGHECvTSVclrwhXPjlUwhcbXB9mfxQ=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    git
    pkg-config
    python3
  ];

  buildInputs = [
    zlib
    libGL
    SDL2
  ];

  patches = [
    ./no-format.patch
  ];

  buildPhase = ''
    for input in src/assets/ntsc-final/lang/*.json; do
      python3 tools/assetmgr/mklang $input en --headers-only
    done
    for input in src/assets/ntsc-final/pads/*.json; do
      python3 tools/assetmgr/mkpads $input --headers-only
    done
    for input in src/assets/ntsc-final/tiles/*.json; do
      python3 tools/assetmgr/mktiles $input --headers-only
    done
    python3 tools/assetmgr/mkanims --headers-only
    python3 tools/assetmgr/mksequences --headers-only
    python3 tools/assetmgr/mktextures --headers-only
    make -j4 -f Makefile.port TARGET_PLATFORM=i686-linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/ntsc-final-port/pd.exe $out/bin/perfect-dark

  '';
}
