{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zObflf9BKq24km54LW7It4Lvff0OKYNDb02uatdX7g4=";
  };

  cargoSha256 = "sha256-itL6WpM4OLn4mzdB0ytM2J7F1fRDrXwCaI/8WdLo6y0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=dump::tests"
    "--skip=query::tests"
    "--skip=verify_binary_contains_lints"
  ];

  # use system openssl
  OPENSSL_NO_VENDOR = true;

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
