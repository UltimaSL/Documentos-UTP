import pandas as pd
from tabulate import tabulate

# Datos de la tabla de interrupciones
i_table = [
    [0, 1, "Reloj de Sistema"],
    [1, 2, "Teclado"],
    [2, 0, "Reservada al Controlador PIC"],
    [3, 11, "COM2 y COM4"],
    [4, 12, "COM1 y COM3"],
    [5, 13, "Libre"],
    [6, 14, "Controlador Floppy"],
    [7, 15, "Puerto Paralelo - Impresora"],
    [8, 3, "Reloj (tics) en tiempo real CMOS"],
    [9, 4, "Libre para tarjeta de red, sonido, puerto SCSI"],
    [10, 5, "Libre para tarjeta de red, sonido, puerto SCSI"],
    [11, 6, "Libre para tarjeta de red, sonido, puerto SCSI"],
    [12, 7, "PS-mouse"],
    [13, 8, "Co-procesador matemático"],
    [14, 9, "Canal IDE primario"],
    [15, 9, "Libre"]
]

# Convertir la lista de interrupciones en un DataFrame de pandas
interrupt_df = pd.DataFrame(i_table, columns=["IRQ", "Prioridad", "Función"])

# Función para mostrar la tabla de interrupciones
def display_interrupt_table():
    print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))

# Función para rellenar la tabla de procesos
def rellenar_tabla(interrupcion, inicio, duracion):
    for i in range(len(i_table)):
        if i_table[i][0] == interrupcion:
            prioridad = i_table[i][1]
            break  # Terminamos el bucle una vez encontramos la interrupción

    tabla_procesos.append([interrupcion, prioridad, inicio, duracion, 0])

# Función principal
def main():
    global tabla_procesos
    tabla_procesos = []  # Inicialización de la tabla de procesos vacía

    ciclo1 = True
    while ciclo1:
        # Solicitar datos del usuario
        tiempo_i = int(input("Introduzca el tiempo inicial del programa general: "))
        tiempo_f = int(input("Introduzca el tiempo final del programa general: "))

        # Mostrar la tabla formateada
        display_interrupt_table()

        # Solicitar datos para las interrupciones
        ciclo2 = True
        while ciclo2:
            interrupcion = int(input("Introduzca su interrupción: "))
            inicio = int(input("Introduzca el inicio de la interrupción: "))
            duracion = int(input("Introduzca la duración de la interrupción: "))
            
            # Llamamos a la función para rellenar la tabla de procesos
            rellenar_tabla(interrupcion, inicio, duracion)

            opcion = input("¿Desea continuar con la captura de interrupciones? (s/n): ")
            if opcion.lower() != 's':
                ciclo2 = False

        opcion = input("¿Desea continuar con el programa general? (s/n): ")
        if opcion.lower() != 's':
            ciclo1 = False

    # Mostrar la tabla final de procesos
    print("\nTabla de Procesos:")
    print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final"], tablefmt='grid'))

    print("Programa finalizado.")

if __name__ == "__main__":
    main()

