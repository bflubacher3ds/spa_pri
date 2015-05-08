# This will automatically determine the A3DT variable

isEmpty(A3DT) {
    A3DT=$$(A3DT)
    !isEmpty(A3DT) {
        message(Using environment variable for A3DT)
    } else {
        isEmpty(SPA_ROOT) : error(SPA_ROOT must be defined)
        isEmpty(SPA_MAJOR_VERSION) : error(SPA_MAJOR_VERSION must be defined)
        isEmpty(SPA_SERVICE_PACK) : error(SPA_SERVICE_PACK must be defined)
        isEmpty(SPA_HOTFIX) {
            A3DT=$${SPA_ROOT}/acisR$${SPA_MAJOR_VERSION}sp$${SPA_SERVICE_PACK}
        } else {
            A3DT=$${SPA_ROOT}/acisR$${SPA_MAJOR_VERSION}sp$${SPA_SERVICE_PACK}hf$${SPA_HOTFIX}
        }
    }
    !exists($${A3DT}) : error(Unable to determine ACIS path. Tried $${A3DT})
}
