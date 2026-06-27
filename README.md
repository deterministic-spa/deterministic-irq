# Deterministic `IRQ`

Este script configura la afinidad de las IRQ MSI de un dispositivo PCI y ajusta la prioridad de los hilos de interrupción asociados.

## Requisitos

- Linux
- Bash
- Permisos de root
- `ps`, `grep`, `awk` y `chrt`

## Clonación

```bash
git clone https://github.com/deterministic-spa/deterministic-irq.git
cd deterministic-irq
```

## Uso

```bash
sudo ./deterministic_irq.sh <id_pci> <afinidad_cpu> <prioridad_hebras>
```

### Ejemplo

```bash
sudo ./deterministic_irq.sh 0000:03:00.0 2 85
```

### Nota

El parámetro `<afinidad_cpu>` corresponde a una máscara de CPU expresada en formato decimal.

Ejemplos:

- 1 → CPU 0
- 2 → CPU 1
- 4 → CPU 2
- 8 → CPU 3
