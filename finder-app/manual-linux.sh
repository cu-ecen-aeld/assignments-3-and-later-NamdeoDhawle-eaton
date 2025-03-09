#!binbash
# Script outline to install and build kernel.
# Author Siddhant Jajoo.

set -e
set -u

OUTDIR=tmpaeld
KERNEL_REPO=gitgit.kernel.orgpubscmlinuxkernelgitstablelinux-stable.git
KERNEL_VERSION=v5.15.163
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo Using default directory ${OUTDIR} for output
else
	OUTDIR=$1
	echo Using passed directory ${OUTDIR} for output
fi

mkdir -p ${OUTDIR}

cd $OUTDIR
if [ ! -d ${OUTDIR}linux-stable ]; then
    #Clone only if the repository does not exist.
	echo CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}linux-stablearch${ARCH}bootImage ]; then
    cd linux-stable
    echo Checking out version ${KERNEL_VERSION}
    git checkout ${KERNEL_VERSION}

    # TODO Add your kernel build steps here
fi

echo Adding the Image in outdir

echo Creating the staging directory for the root filesystem
cd $OUTDIR
if [ -d ${OUTDIR}rootfs ]
then
	echo Deleting rootfs directory at ${OUTDIR}rootfs and starting over
    sudo rm  -rf ${OUTDIR}rootfs
fi

# TODO Create necessary base directories

cd $OUTDIR
if [ ! -d ${OUTDIR}busybox ]
then
git clone gitbusybox.netbusybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO  Configure busybox
else
    cd busybox
fi

# TODO Make and install busybox

echo Library dependencies
${CROSS_COMPILE}readelf -a binbusybox  grep program interpreter
${CROSS_COMPILE}readelf -a binbusybox  grep Shared library

# TODO Add library dependencies to rootfs

# TODO Make device nodes

# TODO Clean and build the writer utility

# TODO Copy the finder related scripts and executables to the home directory
# on the target rootfs

# TODO Chown the root directory

# TODO Create initramfs.cpio.gz