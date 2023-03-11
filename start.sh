#!/bin/zsh

main() {

  if [[ $1 == "--install" ]]; then
    echo "Liste des iso disponibles :"
    for file in *.iso; do
      echo "${file%.*}"
    done
    printf "\n"
    read -r input
    install "$input"
  else
    echo "Liste des vm disponibles :"
    for file in *.qcow2; do
      echo "${file%.*}"
    done
    printf "\n"
    read -r input
    start "$input"
  fi

}

install() {
  input="$1.qcow2"
  qemu-img create -f qcow2 ./"$input" 20G
  sudo chmod u+x start.sh
}

start() {
  cdrom="$1.iso"
  drive_file="$1.qcow2"

  qemu-system-x86_64 \
    -m 2048 \
    -vga virtio \
    -usb \
    -device usb-tablet \
    -machine type=q35,accel=hvf \
    -smp 2 \
    -cdrom "$cdrom" \
    -drive file="$drive_file",if=virtio \
    -cpu Nehalem \
    -net nic \
    -net user,hostfwd=tcp::2222-:22
}

main "$@"
exit
