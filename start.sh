#!/bin/zsh

main() {
  source .env
  CDROM=${CDROM}
  DRIVE_FILE=${DRIVE_FILE}

  case "$1" in
    "--install")
      install
      ;;
    "--debian")
      startDebian
      ;;
    "--ubuntu")
      startUbuntu
      ;;
    *)
      startUbuntu
      ;;
  esac
}

install() {
  qemu-img create -f qcow2 ./"$DRIVE_FILE" 20G
  sudo chmod +x start.sh
}

startUbuntu() {
  qemu-system-x86_64 \
    -m 4G \
    -vga virtio \
    -usb \
    -device usb-tablet \
    -machine type=q35,accel=hvf \
    -smp 2 \
    -cdrom "$CDROM" \
    -drive file="$DRIVE_FILE",if=virtio \
    -cpu Nehalem \
    -net nic \
    -net user,hostfwd=tcp::2222-:22
}

main "$@"
exit
