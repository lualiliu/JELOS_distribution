# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2020-present Fewtarius

PKG_NAME="modules"
PKG_VERSION="$(date +%Y%m%d)"
PKG_ARCH="any"
PKG_LICENSE="custom"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain rclone portmaster thememaster"
PKG_SHORTDESC="OS Modules Package"
PKG_LONGDESC="OS Modules Package"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"

make_target() {
  :
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config/modules
  cp -rf ${PKG_DIR}/sources/* ${INSTALL}/usr/config/modules
  chmod 0755 ${INSTALL}/usr/config/modules/*
  case ${ARCH} in
    x86_64)
      rm -f "${INSTALL}/usr/config/Start 32bit Retroarch.sh"
    ;;
  esac
}

