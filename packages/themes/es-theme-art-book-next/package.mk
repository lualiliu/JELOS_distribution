# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)
# Copyright (C) 2021 Fewtarius

PKG_NAME="es-theme-art-book-next"
PKG_VERSION="236310621bd5a14fcac26cd480cf8a231844716c"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/anthonycaccese/art-book-next-batocera"
PKG_URL="${PKG_SITE}.git"
PKG_GIT_CLONE_BRANCH="2.0"
GET_HANDLER_SUPPORT="git"
PKG_SHORTDESC="Art Book Next"
PKG_LONGDESC="Art Book Next"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/themes/${PKG_NAME}
  cp -rf * ${INSTALL}/usr/share/themes/${PKG_NAME}
}
