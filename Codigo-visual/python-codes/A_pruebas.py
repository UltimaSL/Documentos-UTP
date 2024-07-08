import pandas as pd
from tabulate import tabulate

# Datos de la tabla de interrupciones
# Cada entrada de la lista contiene el IRQ, la Prioridad y la Función asociada a la interrupción
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

# Función para mostrar la tabla de interrupciones y la tabla de procesos
def display_interrupt_table(tabla_procesos):
    # Mostrar la tabla de interrupciones con formato de tabla
    print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))
    # Mostrar la tabla de procesos con formato de tabla
    print("\nTabla de Procesos:")
    print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final", "Función"], tablefmt='grid'))

# Función para rellenar la tabla de procesos
def rellenar_tabla(interrupcion, inicio, duracion):
    global tabla_procesos  # Referencia a la tabla de procesos global
    for i in range(len(i_table)):
        if i_table[i][0] == interrupcion:  # Buscar la interrupción en la tabla de interrupciones
            prioridad = i_table[i][1]
            funcion = i_table[i][2]
            final = inicio + duracion  # Calcular el tiempo de finalización de la interrupción
            # Añadir la interrupción a la tabla de procesos
            tabla_procesos.append([interrupcion, prioridad, inicio, duracion, final, funcion])
            # Ordenar la tabla de procesos por el tiempo de inicio
            tabla_procesos.sort(key=lambda int: int[2])
            break  # Terminar el bucle una vez se encuentra la interrupción

# Función para calcular el manejo de interrupciones
def calcular_interrupciones(tiempo_f, tiempo_i):
    # Lista de interrupciones, comenzando con el programa general
    interrupciones = [{"prioridad": 16, "duracion": tiempo_f, "nombre": "Programa general"}]
    
    tiempo_A = tiempo_i  # Tiempo actual
    i = 0
    cola_procesos = []  # Cola de procesos a manejar
    bitacora = []  # Bitácora de eventos de interrupción

    while interrupciones and i < len(tabla_procesos):
        actual = interrupciones.pop(0)  # Obtener la siguiente interrupción
        cola_procesos.append([actual["nombre"], tiempo_A])  # Añadirla a la cola de procesos

        i_begin = tabla_procesos[i][2]  # Tiempo de inicio de la interrupción actual
        nueva_interrupcion = {"prioridad": tabla_procesos[i][1], "duracion": tabla_procesos[i][3], "nombre": tabla_procesos[i][5]}
        i += 1

        tiempo_d = i_begin - tiempo_A  # Calcular el tiempo de duración hasta la siguiente interrupción

        if actual["duracion"] - tiempo_d <= 0:
            tiempo_A += actual["duracion"]  # Actualizar el tiempo actual
            cola_procesos[-1].append(tiempo_A)
            bitacora.append([actual["nombre"], tiempo_A - actual["duracion"], tiempo_A, 'No', 0])
            i -= 1  # Revertir el índice para procesar la misma interrupción de nuevo
            continue

        actual["duracion"] -= tiempo_d  # Reducir la duración restante de la interrupción actual
        tiempo_A += tiempo_d  # Actualizar el tiempo actual
        cola_procesos[-1].append(tiempo_A)
        bitacora.append([actual["nombre"], tiempo_A - tiempo_d, tiempo_A, 'Sí', actual["duracion"]])

        if nueva_interrupcion["prioridad"] < actual["prioridad"]:
            interrupciones.insert(0, actual)  # Reinsertar la interrupción actual
            interrupciones.insert(0, nueva_interrupcion)  # Insertar la nueva interrupción
        else:
            temporal = []
            temporal.append(actual)
            while interrupciones and interrupciones[0]["prioridad"] < nueva_interrupcion["prioridad"]:
                temporal.append(interrupciones.pop(0))
            temporal.append(nueva_interrupcion)
            interrupciones = temporal + interrupciones

    while interrupciones:
        actual = interrupciones.pop(0)
        cola_procesos.append([actual["nombre"], tiempo_A])
        tiempo_A += actual["duracion"]
        cola_procesos[-1].append(tiempo_A)
        bitacora.append([actual["nombre"], tiempo_A - actual["duracion"], tiempo_A, 'No', 0])

    # Imprimir los cola_procesos en forma de tabla
    print("\nCola de procesos")
    print(tabulate(cola_procesos, headers=["Interrupción", "Tiempo Inicial", "Tiempo Final"], tablefmt='grid'))

    # Imprimir la bitácora de interrupciones en forma de tabla
    print("\nTabla de Bitacora:")
    print(tabulate(bitacora, headers=["Interrupción", "Tiempo Inicial", "Tiempo Final", "Interrupción Realizada", "Tiempo Restante"], tablefmt='grid'))

# Función principal
def main():
    global tabla_procesos
    tabla_procesos = []  # Inicialización de la tabla de procesos vacía

    ciclo1 = True
    while ciclo1:
        # Solicitar el tiempo inicial y la duración del programa general
        tiempo_i = int(input("Introduzca el tiempo inicial del programa general: "))
        tiempo_f = int(input("Introduzca la duracion del programa general: "))

        # Mostrar la tabla de interrupciones
        print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))

        ciclo2 = True
        while ciclo2:
            # Solicitar la interrupción del usuario
            interrupcion = int(input("Introduzca su interrupción: "))

            if interrupcion != 2:
                # Solicitar el tiempo de inicio y duración de la interrupción
                inicio = int(input("Introduzca el inicio de la interrupción (si es menor al tiempo inicial del programa se le sumara este): ")) + tiempo_i
                duracion = int(input("Introduzca la duración de la interrupción: "))

                # Añadir la interrupción a la tabla de procesos
                rellenar_tabla(interrupcion, inicio, duracion)

                # Preguntar si desea continuar capturando interrupciones
                opcion = input("¿Desea continuar con la captura de interrupciones? (s/n): ")
                if opcion.lower() != 's':
                    ciclo2 = False
            else:
                # No se puede capturar el IRQ 2 porque está reservado
                print("No se puede capturar el IRQ 2 porque está reservado")

        # Mostrar la tabla de procesos
        print("\nTabla de Procesos:")
        print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final", "Función"], tablefmt='grid'))
        
        # Calcular el manejo de interrupciones
        calcular_interrupciones(tiempo_f, tiempo_i)

        # Preguntar si desea continuar con el programa general
        opcion = input("\n\n¿Desea continuar con el programa general? (s/n): ")
        if opcion.lower() != 's':
            ciclo1 = False
            
    print("Programa finalizado.")

# Ejecutar la función principal si este script se ejecuta directamente
if __name__ == "__main__":
    main()

