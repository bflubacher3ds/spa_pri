# This will automatically determine the ARCH variable corresponding
# to the ACIS/IOP binary folder

isEmpty(ARCH) {
    ARCH=$$(ARCH)
    !isEmpty(ARCH) {
        message(Using environment variable for ARCH)
    } else {
      win32 {
        version_info = $$system($$QMAKE_CXX 2>&1)
        exp = $$find(version_info,18\\.00)
        !isEmpty(exp) : VC=VC12
        exp = $$find(version_info,17\\.00)
        !isEmpty(exp) : VC=VC11
        exp = $$find(version_info,16\\.00)
        !isEmpty(exp) : VC=VC10
        exp = $$find(version_info,x86)
        !isEmpty(exp) : ARCH=NT_$${VC}_DLL
        exp = $$find(version_info,x64)
        !isEmpty(exp) : ARCH=NT_$${VC}_64_DLL
      }
      macx:ARCH=macos_b64
      unix:!macx:ARCH=linux_a64
    }
}
