{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "sftpgo";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "drakkan";
    repo = "sftpgo";
    rev = "refs/tags/v${version}";
    hash = "sha256-cSA7ndpIV3VvIZTBa9NCIlJn57EtT1qxrB0UsMENUS0=";
  };

  vendorHash = "sha256-C45KA+9tdj+fR3DUBLdG2dGzT59zuAJczpKVoiAZ7lg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/drakkan/sftpgo/v2/internal/version.commit=${src.rev}"
    "-X github.com/drakkan/sftpgo/v2/internal/version.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "." ];

  postInstall = ''
    $out/bin/sftpgo gen man
    installManPage man/*.1

    installShellCompletion --cmd sftpgo \
      --bash <($out/bin/sftpgo gen completion bash) \
      --zsh <($out/bin/sftpgo gen completion zsh) \
      --fish <($out/bin/sftpgo gen completion fish)
  '';

  meta = with lib; {
    homepage = "https://github.com/drakkan/sftpgo";
    changelog = "https://github.com/drakkan/sftpgo/releases/tag/v${version}";
    description = "Fully featured and highly configurable SFTP server";
    longDescription = ''
      Fully featured and highly configurable SFTP server
      with optional HTTP/S, FTP/S and WebDAV support.
      Several storage backends are supported:
      local filesystem, encrypted local filesystem, S3 (compatible) Object Storage,
      Google Cloud Storage, Azure Blob Storage, SFTP.
    '';
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ thenonameguy ];
  };
}
