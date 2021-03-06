TEMPLATE = app
TARGET = SperoCoin-qt
VERSION = ANDROID-2.6.4.6
INCLUDEPATH += src src/json src/qt
QT += core gui network androidextras
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE __STDC_FORMAT_MACROS __STDC_LIMIT_MACROS
CONFIG += no_include_pwd
CONFIG += thread
#CONFIG += static

# for boost 1.37, add -mt to the boost libraries
# use: qmake BOOST_LIB_SUFFIX=-mt
# for boost thread win32 with _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX=_win32-...
# or when linking against a specific BerkelyDB version: BDB_LIB_SUFFIX=-4.8

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

USE_UPNP=1
USE_IPV6=0
USE_LEVELDB=1
USE_QRCODE=1
#USE_ASM=1

QMAKE_CXXFLAGS=-fstack-protector-strong -DANDROID -fno-builtin-memmove --sysroot=E:/Android/AndroidNDK/android-ndk-r10d/platforms/android-9/arch-arm -std=c++11

BOOST_LIB_SUFFIX=-gcc-mt-s-1_57

#        SOURCES += src/txdb-bdb.cpp

contains(DEBUG, 1) {
    QMAKE_CXXFLAGS -= -O2
    QMAKE_CFLAGS -= -O2

    QMAKE_CFLAGS += -g -O0
    QMAKE_CXXCFLAGS += -g -O0
}

android {
        message("Using Android settings")

        # change to your own path, where you will store all needed libraries with 'git clone' commands below.
        MAIN_PATH = E:/Android/deps
        # change to your own Android NDK path
        NDK_PATH = E:/Android/AndroidNDK/android-ndk-r10d

        # git clone https://github.com/PurpleI2P/MiniUPnP-for-Android-Prebuilt.git
        # git clone git@github.com:hypnosis-i2p/android-ifaddrs-from-android-source.git
        #boost 53, 62 are not ok
        BOOST_INCLUDE_PATH = $$MAIN_PATH/boost_1_57_0
        BOOST_PATH = $$MAIN_PATH/boost_1_57_0
        #/stage/lib
        OPENSSL_PATH = $$MAIN_PATH/openssl-1.0.1l

        #MINIUPNPC Prebuilt from https://github.com/PurpleI2P/MiniUPnP-for-Android-Prebuilt
        MINIUPNP_PATH = $$MAIN_PATH/MiniUPnP-for-Android-Prebuilt
        MINIUPNPC_LIB_PATH = $$MAIN_PATH/MiniUPnP-for-Android-Prebuilt/miniupnpc-2.0/armeabi-v7a/lib

        IFADDRS_PATH = $$MAIN_PATH/android-ifaddrs-from-android-source
        BDB_PATH = $$MAIN_PATH/db-4.8.30.NC/build_unix

        #added QRENCODE from https://fukuchi.org/works/qrencode/
        #to configure for android arm run ./configure --host=arm-linux --disable-shared
        #then run make
        QRENCODE_INCLUDE_PATH = $$MAIN_PATH/qrencode-4.0.2
        QRENCODE_LIB_PATH = $$MAIN_PATH/qrencode-4.0.2/.libs

        DEFINES += ANDROID=1
        DEFINES += __ANDROID__

        CONFIG += mobility

        MOBILITY =

        INCLUDEPATH += \
                $$NDK_PATH/sources/cxx-stl/gnu-libstdc++/4.9/include \
                $$NDK_PATH/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a/include \
                $$BOOST_INCLUDE_PATH \
                $$BOOST_PATH \
                $$OPENSSL_PATH/include \
                $$IFADDRS_PATH \
                $$BDB_PATH \
                build \
                $$MINIUPNP_PATH/miniupnpc-2.0/include

        SOURCES += $$IFADDRS_PATH/ifaddrs.cpp $$IFADDRS_PATH/bionic_netlink.cpp
        HEADERS += $$IFADDRS_PATH/ifaddrs.h $$IFADDRS_PATH/ErrnoRestorer.h $$IFADDRS_PATH/bionic_netlink.h $$IFADDRS_PATH/bionic_macros.h

        equals(ANDROID_TARGET_ARCH, armeabi-v7a){
                DEFINES += ANDROID_ARM7A
                BOOST_POSTFIX=-gcc-mt-1_57
                LIBS += -L$$BOOST_PATH/stage/lib \
                        -lboost_atomic$$BOOST_POSTFIX \
                        -lboost_chrono$$BOOST_POSTFIX \
                        -lboost_filesystem$$BOOST_POSTFIX \
                        -lboost_program_options$$BOOST_POSTFIX \
                        -lboost_system$$BOOST_POSTFIX \
                        -lboost_thread_pthread$$BOOST_POSTFIX \
                        -L$$OPENSSL_PATH -lcrypto -lssl\
                        -L$$MINIUPNP_PATH/miniupnpc-2.0/armeabi-v7a/lib/ -lminiupnpc

                PRE_TARGETDEPS += $$OPENSSL_PATH/libcrypto.a \
                        $$OPENSSL_PATH/libssl.a
                DEPENDPATH += $$OPENSSL_PATH/include

                 ANDROID_EXTRA_LIBS += $$MINIUPNP_PATH/miniupnpc-2.0/armeabi-v7a/lib/libminiupnpc.so
        }

        equals(ANDROID_TARGET_ARCH, x86){
                error("Android BDB: don't know how to build BDB for Android x86")

                # http://stackoverflow.com/a/30235934/529442
                LIBS += -L$$BOOST_PATH/boost_1_62_0/x86/lib \
                        -lboost_system-gcc-mt-1_62 -lboost_date_time-gcc-mt-1_62 \
                        -lboost_filesystem-gcc-mt-1_62 -lboost_program_options-gcc-mt-1_62 \
                        -L$$OPENSSL_PATH/openssl-1.1.0/x86/lib/ -lcrypto -lssl
#\
#           -L$$MINIUPNP_PATH/miniupnpc-2.0/x86/lib/ -lminiupnpc

                PRE_TARGETDEPS += $$OPENSSL_PATH/openssl-1.1.0/x86/lib/libcrypto.a \
                        $$OPENSSL_PATH/openssl-1.1.0/x86/lib/libssl.a

                DEPENDPATH += $$OPENSSL_PATH/openssl-1.1.0/include

                ANDROID_EXTRA_LIBS += $$OPENSSL_PATH/openssl-1.1.0/x86/lib/libcrypto_1_0_0.so \
                        $$OPENSSL_PATH/openssl-1.1.0/x86/lib/libssl_1_0_0.so
#\
#           $$MINIUPNP_PATH/miniupnpc-2.0/x86/lib/libminiupnpc.so
        }
}

!win32 {
# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
#QMAKE_CXXFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
#QMAKE_LFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
# We need to exclude this for Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
# This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}
# for extra security (see: https://wiki.debian.org/Hardening): this flag is GCC compiler-specific
#-D_FORTIFY_SOURCE=2
QMAKE_CXXFLAGS *= -std=c++11

# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    LIBS += -lqrencode
}

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP MINIUPNP_STATICLIB STATICLIB
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    #LIBS += -lminiupnpc
    win32:LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1"
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

contains(USE_LEVELDB, 1) {
    message(Building with LevelDB transaction index)
    DEFINES += USE_LEVELDB

    INCLUDEPATH += src/leveldb/include src/leveldb/helpers
    LIBS += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a
SOURCES += src/txdb-leveldb.cpp \
    src/bloom.cpp \
    src/hash.cpp \
    src/aes_helper.c \
    src/blake.c \
    src/bmw.c \
    src/cubehash.c \
    src/echo.c \
    src/groestl.c \
    src/jh.c \
    src/keccak.c \
    src/luffa.c \
    src/shavite.c \
    src/simd.c \
    src/skein.c \
    src/fugue.c \
    src/hamsi.c

    !win32 {
        # we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
        genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
    } else {
        # make an educated guess about what the ranlib command is called
        isEmpty(QMAKE_RANLIB) {
            QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
        }
        LIBS += -lshlwapi
        genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libmemenv.a
    }
    genleveldb.target = $$PWD/src/leveldb/libleveldb.a
    genleveldb.depends = FORCE
    PRE_TARGETDEPS += $$PWD/src/leveldb/libleveldb.a
    QMAKE_EXTRA_TARGETS += genleveldb
    # Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
    QMAKE_CLEAN += $$PWD/src/leveldb/libleveldb.a; cd $$PWD/src/leveldb ; $(MAKE) clean
} else {
    message(Building with Berkeley DB transaction index)
    SOURCES += src/txdb-bdb.cpp
}

# regenerate src/build.h
#!windows|contains(USE_BUILD_INFO, 1) {
#    genbuild.depends = FORCE
#    genbuild.commands = cd $$PWD; /bin/sh share/genbuild.sh $$OUT_PWD/build/build.h
#    genbuild.target = $$OUT_PWD/build/build.h
#    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
#    QMAKE_EXTRA_TARGETS += genbuild
#    DEFINES += HAVE_BUILD_INFO
#}

contains(USE_O3, 1) {
    message(Building O3 optimization flag)
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS += -O3
    QMAKE_CFLAGS += -O3
}

#*-g++-32 {
#    message("32 platform, adding -msse2 flag")
#    QMAKE_CXXFLAGS += -msse2
#    QMAKE_CFLAGS += -msse2
#}

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector


# Input
DEPENDPATH += src src/json src/qt
HEADERS += src/qt/bitcoingui.h \
    src/qt/transactiontablemodel.h \
    src/qt/addresstablemodel.h \
    src/qt/optionsdialog.h \
    src/qt/coincontroldialog.h \
    src/qt/coincontroltreewidget.h \
    src/qt/sendcoinsdialog.h \
    src/qt/addressbookpage.h \
    src/qt/signverifymessagedialog.h \
    src/qt/aboutdialog.h \
    src/qt/editaddressdialog.h \
    src/qt/bitcoinaddressvalidator.h \
    src/qt/intro.h \
    src/qt/statisticspage.h \
    src/qt/blockbrowser.h \
    src/alert.h \
    src/addrman.h \
    src/base58.h \
    src/bignum.h \
    src/checkpoints.h \
    src/compat.h \
    src/coincontrol.h \
    src/sync.h \
    src/util.h \
    src/uint256.h \
    src/uint256_t.h \
    src/kernel.h \
    src/scrypt.h \
    src/pbkdf2.h \
    src/serialize.h \
    src/strlcpy.h \
    src/main.h \
    src/miner.h \
    src/net.h \
    src/key.h \
    src/db.h \
    src/txdb.h \
    src/walletdb.h \
    src/script.h \
    src/init.h \
    src/mruset.h \
    src/json/json_spirit_writer_template.h \
    src/json/json_spirit_writer.h \
    src/json/json_spirit_value.h \
    src/json/json_spirit_utils.h \
    src/json/json_spirit_stream_reader.h \
    src/json/json_spirit_reader_template.h \
    src/json/json_spirit_reader.h \
    src/json/json_spirit_error_position.h \
    src/json/json_spirit.h \
    src/qt/clientmodel.h \
    src/qt/guiutil.h \
    src/qt/transactionrecord.h \
    src/qt/guiconstants.h \
    src/qt/optionsmodel.h \
    src/qt/monitoreddatamapper.h \
    src/qt/transactiondesc.h \
    src/qt/transactiondescdialog.h \
    src/qt/bitcoinamountfield.h \
    src/wallet.h \
    src/keystore.h \
    src/qt/transactionfilterproxy.h \
    src/qt/transactionview.h \
    src/qt/walletmodel.h \
    src/bitcoinrpc.h \
    src/qt/overviewpage.h \
    src/qt/csvmodelwriter.h \
    src/crypter.h \
    src/qt/sendcoinsentry.h \
    src/qt/qvalidatedlineedit.h \
    src/qt/bitcoinunits.h \
    src/qt/paymentserver.h \
    src/qt/qvaluecombobox.h \
    src/qt/askpassphrasedialog.h \
    src/protocol.h \
    src/qt/notificator.h \
    src/qt/qtipcserver.h \
    src/allocators.h \
    src/ui_interface.h \
    src/qt/rpcconsole.h \
    src/version.h \
    src/netbase.h \
    src/clientversion.h \
    src/bloom.h \
    src/checkqueue.h \
    src/hash.h \
    src/hashblock.h \
    src/limitedmap.h \
    src/sph_blake.h \
    src/sph_bmw.h \
    src/sph_cubehash.h \
    src/sph_echo.h \
    src/sph_groestl.h \
    src/sph_jh.h \
    src/sph_keccak.h \
    src/sph_luffa.h \
    src/sph_shavite.h \
    src/sph_simd.h \
    src/sph_skein.h \
    src/sph_fugue.h \
    src/sph_hamsi.h \
    src/sph_types.h \
    src/threadsafety.h \
    src/txdb-leveldb.h \
    src/qt/stakereportdialog.h \
    src/permissions.h

SOURCES += src/qt/bitcoin.cpp src/qt/bitcoingui.cpp \
    src/qt/transactiontablemodel.cpp \
    src/qt/intro.cpp \
    src/qt/addresstablemodel.cpp \
    src/qt/optionsdialog.cpp \
    src/qt/sendcoinsdialog.cpp \
    src/qt/coincontroldialog.cpp \
    src/qt/coincontroltreewidget.cpp \
    src/qt/addressbookpage.cpp \
    src/qt/signverifymessagedialog.cpp \
    src/qt/aboutdialog.cpp \
    src/qt/statisticspage.cpp \
    src/qt/blockbrowser.cpp \
    src/qt/editaddressdialog.cpp \
    src/qt/bitcoinaddressvalidator.cpp \
    src/alert.cpp \
    src/version.cpp \
    src/sync.cpp \
    src/util.cpp \
    src/netbase.cpp \
    src/key.cpp \
    src/script.cpp \
    src/main.cpp \
    src/miner.cpp \
    src/init.cpp \
    src/net.cpp \
    src/checkpoints.cpp \
    src/addrman.cpp \
    src/db.cpp \
    src/walletdb.cpp \
    src/qt/clientmodel.cpp \
    src/qt/guiutil.cpp \
    src/qt/transactionrecord.cpp \
    src/qt/optionsmodel.cpp \
    src/qt/monitoreddatamapper.cpp \
    src/qt/transactiondesc.cpp \
    src/qt/transactiondescdialog.cpp \
    src/qt/bitcoinstrings.cpp \
    src/qt/bitcoinamountfield.cpp \
    src/wallet.cpp \
    src/keystore.cpp \
    src/qt/transactionfilterproxy.cpp \
    src/qt/transactionview.cpp \
    src/qt/walletmodel.cpp \
    src/bitcoinrpc.cpp \
    src/rpcdump.cpp \
    src/rpcnet.cpp \
    src/rpcmining.cpp \
    src/rpcwallet.cpp \
    src/rpcblockchain.cpp \
    src/rpcrawtransaction.cpp \
    src/qt/overviewpage.cpp \
    src/qt/csvmodelwriter.cpp \
    src/crypter.cpp \
    src/qt/sendcoinsentry.cpp \
    src/qt/qvalidatedlineedit.cpp \
    src/qt/bitcoinunits.cpp \
    src/qt/qvaluecombobox.cpp \
    src/qt/askpassphrasedialog.cpp \
    src/protocol.cpp \
    src/qt/notificator.cpp \
    src/qt/paymentserver.cpp \
    src/qt/qtipcserver.cpp \
    src/qt/rpcconsole.cpp \
    src/noui.cpp \
    src/kernel.cpp \
    src/scrypt-arm.S \
    src/scrypt-x86.S \
    src/scrypt-x86_64.S \
    src/scrypt.cpp \
    src/pbkdf2.cpp \
    src/qt/stakereportdialog.cpp \
    src/permissions.cpp

RESOURCES += src/qt/bitcoin.qrc

FORMS += \
    src/qt/forms/intro.ui \
    src/qt/forms/coincontroldialog.ui \
    src/qt/forms/sendcoinsdialog.ui \
    src/qt/forms/addressbookpage.ui \
    src/qt/forms/signverifymessagedialog.ui \
    src/qt/forms/aboutdialog.ui \
    src/qt/forms/editaddressdialog.ui \
    src/qt/forms/transactiondescdialog.ui \
    src/qt/forms/overviewpage.ui \
    src/qt/forms/sendcoinsentry.ui \
    src/qt/forms/statisticspage.ui \
    src/qt/forms/blockbrowser.ui \
    src/qt/forms/askpassphrasedialog.ui \
    src/qt/forms/rpcconsole.ui \
    src/qt/forms/optionsdialog.ui \
    src/qt/forms/stakereportdialog.ui

contains(USE_QRCODE, 1) {
HEADERS += src/qt/qrcodedialog.h
SOURCES += src/qt/qrcodedialog.cpp
FORMS += src/qt/forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to src/qt/bitcoin.qrc under translations/
TRANSLATIONS = $$files(src/qt/locale/bitcoin_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/src/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# "Other files" to show in Qt Creator
OTHER_FILES += \
    doc/*.rst doc/*.txt doc/README README.md res/bitcoin-qt.rc

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    macx:BOOST_LIB_SUFFIX = -mt
    windows:BOOST_LIB_SUFFIX = -mt
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

isEmpty(BDB_LIB_PATH) {
    macx:BDB_LIB_PATH = /opt/local/lib/db48
}

isEmpty(BDB_LIB_SUFFIX) {
    macx:BDB_LIB_SUFFIX = -4.8
}

isEmpty(BDB_INCLUDE_PATH) {
    macx:BDB_INCLUDE_PATH = /opt/local/include/db48
}

!win32:!macx {
    android {
        #LIBS += $$BDB_PATH/libdb.a $$BDB_PATH/libdb_cxx.a
        LIBS += -L$$BDB_PATH
    }
    # _FILE_OFFSET_BITS=64 lets 32-bit fopen transparently support large files.
    DEFINES += _FILE_OFFSET_BITS=64
}

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx
LIBS += -lz -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread_pthread$$BOOST_THREAD_LIB_SUFFIX
!win32:LIBS += -ldl

android {
    CXXFLAGS += -O0 -g
#    LIBS += $$NDK_PATH/sources/cxx-stl/stlport/libs/armeabi-v7a/libstlport_static.a
#    LIBS +=$$BDB_PATH/libdb_cxx.a $$BDB_PATH/libdb.a
     LIBS += -ldl
}

system($$QMAKE_LRELEASE -silent $$TRANSLATIONS)

android {
    DISTFILES += \
        AndroidManifest.xml \
        res/values/libs.xml
}

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../deps/MiniUPnP-for-Android-Prebuilt/miniupnpc-2.0/armeabi-v7a/lib/libminiupnpc.so
}
