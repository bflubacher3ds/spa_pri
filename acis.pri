!include(util/arch.pri):error(Unable to include util/arch.pri from acis.pri)
!include(util/a3dt.pri):error(Unable to include util/a3dt.pri from acis.pri)

INCLUDEPATH += "$${A3DT}/include"

win32 {
    release:d=
    debug:d=d
    LIBS *= "$${A3DT}/$${ARCH}$${d}/code/lib/SpaACIS$${d}.lib"
    DEFINES *= SPA_NO_AUTO_LINK
    contains(SPA_MAJOR_VERSION, 24) : DEFINES *= NO_FILEID_DEFINE
}

unix {
    LIBS *= -L$${A3DT}/$${ARCH}/code/bin -lSpaACIS
    LIBS *= -Wl,-rpath,$${A3DT}/$${ARCH}/code/bin
}
