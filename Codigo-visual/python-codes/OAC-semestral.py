import pandas as pd
from tabulate import tabulate


class Pila:
    def __init__(self):
        self.items = []

    def esta_vacia(self):
        return self.items == []

    def apilar(self, item):
        self.items.append(item)

    def desapilar(self):
        if not self.esta_vacia():
            return self.items.pop()

    def ver_tope(self):
        if not self.esta_vacia():
            return self.items[-1]

    def tamano(self):
        return len(self.items)



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

pila=Pila()

# Convertir la lista de interrupciones en un DataFrame de pandas
interrupt_df = pd.DataFrame(i_table, columns=["IRQ", "Prioridad", "Función"])

# Función para mostrar la tabla de interrupciones
def display_interrupt_table():
    print(tabulate(interrupt_df, headers='keys', tablefmt='grid'))

# Función para rellenar la tabla de procesos
def rellenar_tabla(interrupcion, inicio, duracion):
    global tabla_procesos
    for i in range(len(i_table)):
        if i_table[i][0] == interrupcion:
            prioridad = i_table[i][1]
            tabla_procesos.append([interrupcion, prioridad, inicio, duracion, 0, duracion, inicio])
            break  # Terminamos el bucle una vez encontramos la interrupción

# Función para manejar las interrupciones durante la cuenta regresiva
def manejar_interrupciones(tiempo_i, tiempo_f):
    i=16
    x=0
    tiempo_A=0
    while True:
        for j in range(len(tabla_procesos)):
            if j<i and tabla_procesos[j][6]>0 and tabla_procesos[j][7]>=tiempo_i:
                pila.apilar(i)
                i=j
                x=1
        
        tabla_procesos[i][6]=tabla_procesos[i][6]-1
        tiempo_A = tiempo_A+1
                

# Función principal
def main():
    global tabla_procesos
    tabla_procesos = []  # Inicialización de la tabla de procesos vacía

    ciclo1 = True
    while ciclo1:
        # Solicitar datos del usuario
        tiempo_i = int(input("Introduzca el tiempo inicial del programa general: "))
        tiempo_f = int(input("Introduzca el tiempo final del programa general: "))

        rellenar_tabla(16, tiempo_i, tiempo_f)

        # Mostrar la tabla formateada
        display_interrupt_table(tabla_procesos)

        # Solicitar datos para las interrupciones
        ciclo2 = True
        while ciclo2:
            interrupcion = int(input("Introduzca su interrupción: "))

            if interrupcion != 2:
                inicio = int(input("Introduzca el inicio de la interrupción: "))
                duracion = int(input("Introduzca la duración de la interrupción: "))

                # Llamamos a la función para rellenar la tabla de procesos
                rellenar_tabla(interrupcion, inicio, duracion)

                opcion = input("¿Desea continuar con la captura de interrupciones? (s/n): ")
                if opcion.lower() != 's':
                    ciclo2 = False
            else:
                print("No se puede capturar el IRQ 2 porque está reservado")

        # Iniciar cuenta regresiva y manejar interrupciones
        manejar_interrupciones(tiempo_i, tiempo_f)

        opcion = input("¿Desea continuar con el programa general? (s/n): ")
        if opcion.lower() != 's':
            ciclo1 = False

    # Mostrar la tabla final de procesos
    print("\nTabla de Procesos:")
    print(tabulate(tabla_procesos, headers=["IRQ", "Prioridad", "Inicio", "Duración", "Final"], tablefmt='grid'))

    print("Programa finalizado.")

if __name__ == "__main__":
    main()