# This will automatically determine the X3DT variable

isEmpty(X3DT) {
    X3DT=$$(X3DT)
    !isEmpty(X3DT) {
        message(Using environment variable for X3DT)
    } else {
        isEmpty(SPA_ROOT) : error(SPA_ROOT must be defined)
        isEmpty(SPA_MAJOR_VERSION) : error(SPA_MAJOR_VERSION must be defined)
        isEmpty(SPA_SERVICE_PACK) : error(SPA_SERVICE_PACK must be defined)
        isEmpty(SPA_HOTFIX) {
            X3DT=$${SPA_ROOT}/iopR$${SPA_MAJOR_VERSION}sp$${SPA_SERVICE_PACK}
        } else {
            X3DT=$${SPA_ROOT}/iopR$${SPA_MAJOR_VERSION}sp$${SPA_SERVICE_PACK}hf$${SPA_HOTFIX}
        }
    }
    !exists($${X3DT}) : error(Unable to determine InterOp path. Tried $${X3DT})
}
