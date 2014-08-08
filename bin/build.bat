set local
set BUILD=%1
set "var1=%BUILD:*_=%"
echo var1 = %var1%

set BUILD=%1
if "%BUILD:~-7%" == "_vmware" (
  set template=%BUILD:~0,-7%
  set builder=vmware-iso
  set spec=vmware
)
if "%BUILD:~-7%" == "_vcloud" (
  set template=%BUILD:~0,-7%
  set builder=vmware-iso
  set spec=vcloud
)
if "%BUILD:~-11%" == "_virtualbox" (
  set template=%BUILD:~0,-11%
  set builder=virtualbox-iso
  set spec=virtualbox
)

if "%spec%x"=="x" (
  echo Wrong build parameter!
  goto :EOF
)

echo template = %template%
echo builder = %builder%
echo spec = %spec%

if exist output-%builder% (
  rmdir /S /Q output-%builder%
)
packer build --only=%builder% %template%_%spec%.json
if ERRORLEVEL 1 goto :EOF

if exist %~dp0\test-box-%spec%.bat (
  call %~dp0\test-box-%spec%.bat %template%_%spec%.box %template%
) 