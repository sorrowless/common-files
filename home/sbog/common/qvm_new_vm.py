#!/bin/env python

import argparse
import subprocess
import os
import sys

memory = 2048
uefi = True
uefipath = '/tmp/ovmf_x64.bin'
createdisk = False
disksize = '10G'
diskpath = '/data/arch.img'
isopath =  '/data/images/soft/archlinux-2014.06.01-dual.iso'
logfile = '/tmp/arch.ovmf.log'


parser = argparse.ArgumentParser(description='Process virtual machine creation')
parser.add_argument('-m', '--memory', action='store', help='Amount of RAM to allocate to virtual machine', nargs='?', const=2048, default=2048, type=int)
parser.add_argument('--uefi-path', action='store', help='Path to UEFI image in OVMF format', nargs='?', required=True)
parser.add_argument('--disk-path', action='store', help='Path to target image file', nargs='?', required=True)
parser.add_argument('-i', '--iso-path', action='store', help='Path to source ISO file', nargs='?', required=True)
parser.add_argument('-l', '--log-file', action='store', help='Path to logfile', nargs='?', const='/tmp/vm.log', default='/tmp/vm.log')
parser.add_argument('-v', '--verbose', action='count')
parser.add_argument('--version', action='version', version='%(prog)s 1.0.0')

args = parser.parse_args()
# Basic virtual machine properties: a recent i440fx machine type, KVM
# acceleration, 2048 MB RAM, two VCPUs.
OPTS = "-M pc-i440fx-2.1 -enable-kvm -m {memory} -smp 2".format(memory=args.memory)

# The OVMF binary, including the non-volatile variable store, appears as a
# "normal" qemu drive on the host side, and it is exposed to the guest as a
# persistent flash device.
if uefi:
  OPTS += " -drive if=pflash,format=raw,file={uefipath}".format(uefipath=args.uefi_path)

# The hard disk is exposed to the guest as a virtio-block device. OVMF has a
# driver stack that supports such a disk. We specify this disk as first boot
# option. OVMF recognizes the boot order specification.
if createdisk:
  pass
  #TODO create disk

OPTS += " -drive id=disk0,if=none,format=qcow2,file={diskpath}".format(diskpath=args.disk_path)
OPTS += " -device virtio-blk-pci,drive=disk0,bootindex=0"

# The Fedora installer disk appears as an IDE CD-ROM in the guest. This is
# the 2nd boot option.
OPTS += " -drive id=cd0,if=none,format=raw,readonly"
OPTS += ",file={isopath}".format(isopath=args.iso_path)
OPTS += " -device ide-cd,bus=ide.1,drive=cd0,bootindex=1"

# The following setting enables S3 (suspend to RAM). OVMF supports S3
# suspend/resume.
OPTS += " -global PIIX4_PM.disable_s3=0"

# OVMF emits a number of info / debug messages to the QEMU debug console, at
# ioport 0x402. We configure qemu so that the debug console is indeed
# available at that ioport. We redirect the host side of the debug console to
# a file.
OPTS += " -global isa-debugcon.iobase=0x402 -debugcon file:{logfile}".format(logfile=args.log_file)

# QEMU accepts various commands and queries from the user on the monitor
# interface. Connect the monitor with the qemu process's standard input and
# output.
OPTS += " -monitor stdio"
# Normally, qemu provides the guest with a UEFI-conformant network driver
# from the iPXE project, in the form of a PCI expansion ROM. For this test,
# we disable the expansion ROM and allow OVMF's built-in virtio-net driver to
# take effect.
#
# On the host side, we use the SLIRP ("user") network backend, which has
# relatively low performance, but it doesn't require extra privileges from
# the user executing qemu.
OPTS += " -netdev id=net0,type=user"
OPTS += " -device virtio-net-pci,netdev=net0,romfile="

# A Spice QXL GPU is recommended as the primary VGA-compatible display
# device. It is a full-featured virtual video card, with great operating
# system driver support. OVMF supports it too.
OPTS += " -device qxl-vga"

if __name__ == "__main__":
  print('options is: {}'.format(OPTS))
  subprocess.call('qemu-system-x86_64 {}'.format(OPTS), shell=True)
