tmp = $$(HOOPS_VERSION)
!isEmpty(tmp) {
    message(Using environment variable for HOOPS_VERSION)
    HOOPS_VERSION=$$tmp
}

isEmpty(HOOPS_VERSION) : error(HOOPS_VERSION must be defined)

isEmpty(HOOPS_INSTALL_DIR) {
  HOOPS_INSTALL_DIR=$$(HOOPS_INSTALL_DIR)
  !isEmpty(HOOPS_INSTALL_DIR) {
    message(Using environment variable for HOOPS_INSTALL_DIR)
  } else {
    isEmpty(SPA_ROOT) : error(SPA_ROOT must be defined)
    HOOPS_INSTALL_DIR=$${SPA_ROOT}/HOOPS/HOOPS_3DF_$${HOOPS_VERSION}
    !exists($$HOOPS_INSTALL_DIR) {
      HOOPS_INSTALL_DIR=$${SPA_ROOT}/HOOPS_3DF_$${HOOPS_VERSION}
    }
  }

  !exists($$HOOPS_INSTALL_DIR) : error(Unable to determine HOOPS installation location. Tried $${HOOPS_INSTALL_DIR})
  
  win32 {
    version_info = $$system($$QMAKE_CXX 2>&1)
    exp = $$find(version_info,18\\.00) 
    !isEmpty(exp):VC=VC12
    exp = $$find(version_info,17\\.00)
    !isEmpty(exp):VC=VC11
    exp = $$find(version_info,16\\.00)
    !isEmpty(exp):VC=VC10
    exp = $$find(version_info,x86)
    !isEmpty(exp) : HOOPS_ARCH=nt_i386_$${VC}
    exp = $$find(version_info,x64)
    !isEmpty(exp) : HOOPS_ARCH=nt_x64_$${VC}
  }
  macx:HOOPS_ARCH=osx
  unix:!macx:HOOPS_ARCH=linux_x86_64

  !exists($${HOOPS_INSTALL_DIR}/bin/$${HOOPS_ARCH}):error(Unable to determine HOOPS installation location. Tried $${HOOPS_INSTALL_DIR}/bin/$${HOOPS_ARCH})

  hoops_dirs=base_stream hoops_3dgs hoops_mvo hoops_stream utility
  win32 {
    debug:d=d
    mtmd=_md
    DEFINES*=IS_WIN
  }
  unix {
    d=
    DEFINES*=IS_X11
    is_19 = $$find(HOOPS_VERSION, 19[0-9][0-9])
    !isEmpty(is_19) {
      for(hoops_dir, hoops_dirs) {
        libpaths *= $${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/lib/$${HOOPS_ARCH}
      }
    } else {
      hoops_dirs *= hoops_hardcopy
      libpaths *= $${HOOPS_INSTALL_DIR}/bin/$${HOOPS_ARCH}
    }
    for(libpath, libpaths) {
        LIBS *= -L$${libpath} -Wl,-rpath,$${libpath}
    }
    !macx:LIBS *= -lX11
  }
  for(hoops_dir, hoops_dirs) {
    exists($${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/include) :
      INCLUDEPATH *= "$${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/include"
    exists($${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/source) :
      INCLUDEPATH *= "$${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/source"

    hoops_lib = $${hoops_dir}$${d}
    contains(hoops_dir, "hoops_3dgs") {
      win32:hoops_lib = hoops$${d}
      unix:hoops_lib = hoops$${HOOPS_VERSION}
    }
    contains(hoops_dir, "utility") {
      win32:hoops_lib = hoops_utilsstat$${d}$${mtmd}
      unix:hoops_lib = hoops_utils
    }
    win32:LIBS *= "$${HOOPS_INSTALL_DIR}/Dev_Tools/$${hoops_dir}/lib/$${HOOPS_ARCH}/$${hoops_lib}.lib"
    unix:LIBS *= -l$${hoops_lib}
  }
}
