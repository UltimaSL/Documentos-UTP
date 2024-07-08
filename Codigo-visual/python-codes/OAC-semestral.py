import pandas as pd
from tabulate import tabulate
from collections import deque

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
    [15, 9, "Libre"],
    [16, 16, "Programa general"]
]

# Convertir la lista de interrupciones en un DataFrame de pandas
interrupt_df = pd.DataFrame(i_table, columns=["IRQ", "Prioridad", "Función"])

# Función para mostrar la tabla de interrupciones
def display_interrupt_table(tabla_procesos):
    print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))
    print("\nTabla de Procesos:")
    print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final", "Función"], tablefmt='grid'))

# Función para rellenar la tabla de procesos
def rellenar_tabla(interrupcion, inicio, duracion):
    global tabla_procesos
    for i in range(len(i_table)):
        if i_table[i][0] == interrupcion:
            prioridad = i_table[i][1]
            funcion = i_table[i][2]
            final = inicio + duracion
            tabla_procesos.append([interrupcion, prioridad, inicio, duracion, final, funcion])
            tabla_procesos.sort(key=lambda int: int[2])
            break  # Terminamos el bucle una vez encontramos la interrupción

def calcular_interrupciones(tiempo_f, tiempo_i):
    pila = deque()
    pila.append([16, tiempo_f, "Programa general"])

    tiempo_A = 0+tiempo_i
    i = 0
    cola_procesos = []
    Bitacora = []

    while len(pila) > 0 and i < len(tabla_procesos):
        dip = pila.pop()
        cola_procesos.append([dip[2], tiempo_A])

        i_begin = tabla_procesos[i][2]
        prioridad = tabla_procesos[i][1]
        nombre = tabla_procesos[i][5]
        inicio = tabla_procesos[i][3]
        siguiente = [prioridad, inicio, nombre]
        i += 1

        tiempo_d = i_begin - tiempo_A

        if dip[1] - tiempo_d <= 0:
            tiempo_A += dip[1]
            cola_procesos[-1].append(tiempo_A)
            Bitacora.append([dip[2], tiempo_A - dip[1], tiempo_A, 'No', 0])
            i -= 1
            continue

        dip[1] -= tiempo_d
        tiempo_A += tiempo_d
        cola_procesos[-1].append(tiempo_A)
        Bitacora.append([dip[2], tiempo_A - tiempo_d, tiempo_A, 'Sí', dip[1]])

        if siguiente[0] < dip[0]:
            pila.append(dip)
            pila.append(siguiente)
        else:
            temp_q = deque()
            temp_q.append(dip)
            while pila and pila[-1][0] < siguiente[0]:
                temp_q.append(pila.pop())
            temp_q.append(siguiente)
            while temp_q:
                pila.append(temp_q.pop())

    while len(pila) > 0:
        dip = pila.pop()
        cola_procesos.append([dip[2], tiempo_A])
        tiempo_A += dip[1]
        cola_procesos[-1].append(tiempo_A)
        Bitacora.append([dip[2], tiempo_A - dip[1], tiempo_A, 'No', 0])

    # Imprimir los cola_procesos en forma de tabla
    print("\nTabla de interrupciones:")
    print(tabulate(cola_procesos, headers=["Interrupción", "Tiempo Inicial", "Tiempo Final"], tablefmt='grid'))

    print("\nTabla de Bitacora:")
    print(tabulate(Bitacora, headers=["Interrupción", "Tiempo Inicial", "Tiempo Final", "Interrupción Realizada", "Tiempo Restante"], tablefmt='grid'))

# Función principal
def main():
    global tabla_procesos
    tabla_procesos = []  # Inicialización de la tabla de procesos vacía

    ciclo1 = True
    while ciclo1:
        tiempo_i = int(input("Introduzca el tiempo inicial del programa general: "))
        tiempo_f = int(input("Introduzca la duracion del programa general: "))

        print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))

        ciclo2 = True
        while ciclo2:
            interrupcion = int(input("Introduzca su interrupción: "))

            if interrupcion != 2:
                inicio = int(input("Introduzca el inicio de la interrupción (si es menor al tiempo inicial del programa se le sumara este): "))+tiempo_i
                duracion = int(input("Introduzca la duración de la interrupción: "))

                rellenar_tabla(interrupcion, inicio, duracion)

                opcion = input("¿Desea continuar con la captura de interrupciones? (s/n): ")
                if opcion.lower() != 's':
                    ciclo2 = False
            else:
                print("No se puede capturar el IRQ 2 porque está reservado")

        calcular_interrupciones(tiempo_f, tiempo_i)

        opcion = input("¿Desea continuar con el programa general? (s/n): ")
        if opcion.lower() != 's':
            ciclo1 = False

    print("\nTabla de Procesos:")
    print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final", "Función"], tablefmt='grid'))
    print("Programa finalizado.")

if __name__ == "__main__":
    main()

