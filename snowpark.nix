{ lib
, buildPythonPackage
, fetchPypi
, snowflake-connector-python
, setuptools
, wheel
, cloudpickle
, pyyaml
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-epu8R+rGhit7zRcs7I5nhupsdbPcJ6I2a5MPsOzLDKU=";
  };

  propagatedBuildInputs = [
    snowflake-connector-python
    setuptools
    wheel
    cloudpickle
    pyyaml
  ];

  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.snowpark"
  ];

  meta = with lib; {
    description = "Snowflake Snowpark Python API";
    homepage = "https://github.com/snowflakedb/snowpark-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
