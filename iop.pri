!include(util/arch.pri):error(Unable to include util/arch.pri from iop.pri)
!include(util/x3dt.pri):error(Unable to include util/x3dt.pri from iop.pri)

INCLUDEPATH += "$${X3DT}/include"

iop_libs=SPAIInterop SPAIAcis SPAXAcisPMIEntities SPAIopAcis SPAIop

win32 {
    release:d=
    debug:d=d
    DEFINES *= SPA_NO_AUTO_LINK
}

unix {
    LIBS *= -L$${X3DT}/$${ARCH}/code/bin
    LIBS *= -Wl,-rpath,$${X3DT}/$${ARCH}/code/bin
}

for(iop_lib, iop_libs) {
    win32:LIBS+=$${X3DT}/$${ARCH}$${d}/code/lib/$${iop_lib}$${d}.lib
    unix:LIBS+=-l$${iop_lib}
}
