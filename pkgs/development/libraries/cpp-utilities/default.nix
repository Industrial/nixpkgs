{ stdenv
, lib
, fetchFromGitHub
, cmake
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "cpp-utilities";
  version = "5.20.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KOvRNo8qd8nXhh/f3uAN7jOsNMTX8dJRGUHJXP+FdEs=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cppunit ];
  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  preCheck = ''
    checkFlagsArray+=(
      "LD_LIBRARY_PATH=$PWD"
    )
  '';
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
