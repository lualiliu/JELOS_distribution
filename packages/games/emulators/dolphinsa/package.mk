# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present BrooksyTech (https://github.com/brooksytech)

PKG_NAME="dolphinsa"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain libevdev libdrm ffmpeg zlib libpng lzo libusb"
PKG_LONGDESC="Dolphin is a GameCube / Wii emulator, allowing you to play games for these two platforms on PC with improvements. "

case ${DEVICE} in
  RG552|handheld)
    PKG_SITE="https://github.com/dolphin-emu/dolphin"
    PKG_URL="${PKG_SITE}.git"
    PKG_VERSION="d0ed09ab6fe8e19a64e8f1bb2867f9c439616d4c"
    PKG_PATCH_DIRS+=" new"
  ;;
  *)
    PKG_SITE="https://github.com/rtissera/dolphin"
    PKG_URL="${PKG_SITE}.git"
    PKG_VERSION="0b160db48796f727311cea16072174d96b784f80"
    PKG_GIT_CLONE_BRANCH="egldrm"
    PKG_PATCH_DIRS+=" legacy"
  ;;
esac

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
  PKG_CONFIGURE_OPTS_TARGET+=" -DENABLE_X11=OFF \
                               -DENABLE_EGL=ON"
fi

if [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  PKG_CONFIGURE_OPTS_TARGET+=" -DENABLE_X11=OFF \
                               -DENABLE_EGL=ON"
fi

if [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_DEPENDS_TARGET+=" wayland ${WINDOWMANAGER} xorg-server xrandr libXi"
  PKG_CONFIGURE_OPTS_TARGET+=" -DENABLE_X11=ON \
                               -DENABLE_EGL=ON"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]
then
  PKG_DEPENDS_TARGET+=" vulkan-loader vulkan-headers"
  PKG_CONFIGURE_OPTS_TARGET+=" -DENABLE_VULKAN=ON"
fi

PKG_CMAKE_OPTS_TARGET+=" -DENABLE_HEADLESS=ON \
                         -DENABLE_EVDEV=ON \
                         -DTHREADS_PTHREAD_ARG=OFF \
                         -DUSE_DISCORD_PRESENCE=OFF \
                         -DBUILD_SHARED_LIBS=OFF \
                         -DUSE_MGBA=OFF \
                         -DLINUX_LOCAL_DEV=ON \
                         -DENABLE_TESTS=OFF \
                         -DENABLE_LLVM=OFF \
                         -DENABLE_ANALYTICS=OFF \
                         -DENABLE_LTO=ON \
                         -DENABLE_QT=OFF \
                         -DENCODE_FRAMEDUMPS=OFF"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/Binaries/dolphin* ${INSTALL}/usr/bin
  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

  chmod +x ${INSTALL}/usr/bin/start_dolphin.sh

  mkdir -p ${INSTALL}/usr/config/dolphin-emu
  cp -rf ${PKG_BUILD}/Data/Sys/* ${INSTALL}/usr/config/dolphin-emu
  cp -rf ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}/usr/config/dolphin-emu
}

post_install() {
    case ${DEVICE} in
      RG503|RG353P|RG353V)
        DOLPHIN_PLATFORM="drm"
      ;;
      *)
        DOLPHIN_PLATFORM="x11"
      ;;
    esac
    sed -e "s/@DOLPHIN_PLATFORM@/${DOLPHIN_PLATFORM}/g" \
        -i  ${INSTALL}/usr/bin/start_dolphin.sh
}
