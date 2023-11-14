{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, cython
, fetchPypi
, pyarrow
, pythonOlder
, setuptools
, wheel

, asn1crypto
, cffi
, cryptography
, pyopenssl
, pyjwt
, pytz
, requests
, packaging
, charset-normalizer
, idna
, urllib3
, certifi
, typing-extensions
, filelock
, sortedcontainers
, platformdirs
, tomlkit

, keyring
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZU5KH2ikkVRL2PfFqwLrhTHfZ8X0MJ1SU70gQET4obM=";
  };

  nativeBuildInputs = [
    cython
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  pythonRelaxDeps = [
  ];

  propagatedBuildInputs = [
    asn1crypto
    cffi
    cryptography
    pyopenssl
    pyjwt
    pytz
    requests
    packaging
    charset-normalizer
    idna
    urllib3
    certifi
    typing-extensions
    filelock
    sortedcontainers
    platformdirs
    tomlkit
    # pyarrow
  ];

  passthru.optional-dependencies = {
    secure-local-storage = [ keyring ];
  };

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
