#!/bin/bash

configure_irq() {
    local pci_id="$1"
    local cpu_affinity="$2"
    local thread_priority="$3"

    # Validate parameters
    if [ -z "$pci_id" ] || [ -z "$cpu_affinity" ] || [ -z "$thread_priority" ]; then
        echo 'Usage: configure_irqs <pci_id> <cpu_affinity> <thread_priority>' >&2
        return 1
    fi

    # Check if the script is running as root
    if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run as root.' >&2
        return 1
    fi

    local msi_irqs_dir="/sys/bus/pci/devices/$pci_id/msi_irqs"
    if [ ! -d "$msi_irqs_dir" ]; then
        echo "MSI IRQ directory not found: $msi_irqs_dir" >&2
        return 1
    fi

    for msi_irq_path in "$msi_irqs_dir"/*; do
        [ -e "$msi_irq_path" ] || continue
        local msi_irq
        msi_irq="$(basename "$msi_irq_path")"

        local affinity_path="/proc/irq/$msi_irq/smp_affinity"
        [ -e "$affinity_path" ] || continue

        echo "$cpu_affinity" > "$affinity_path"

        local pids
        pids=$(ps -eLo pid,comm | grep "irq/$msi_irq-" | grep -v grep | awk '{print $1}')
        for pid in $pids; do
            chrt -f -p "$thread_priority" "$pid"
        done
    done
}

configure_irq "$@"
