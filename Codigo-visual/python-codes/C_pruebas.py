class Interrupcion:
    def __init__(self, IRQ, prioridad, funcion):
        self.IRQ = IRQ
        self.prioridad = prioridad
        self.funcion = funcion
    def __repr__(self):
        return f"I({self.funcion})"
def_irqs = [0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
def_prios = [1, 2, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7, 8, 9, 10]
def_funcs = ["Reloj del sistema", 
             "Teclado",
             "COM2 y COM4",
             "COM1 y COM3",
             "Libre(5)",
             "Controlador Floppy - Diskette",
             "Puerto Paralelo - Impresora",
             "Reloj (tics) en tiempo real CMOS",
             "Red, sonido, puerto SCSI",
             "Libre(10)",
             "Libre(11)",
             "PS-mouse",
             "Co-procesador matemático",
             "Canal IDE primario(Disco)",
             "Libre(15)"]

interrupciones = {irq: Interrupcion(irq, prio, func) for irq, prio, func in zip(def_irqs, def_prios, def_funcs)}

from collections import deque # lo usamos para implementar la pila de interrupciones

class Ejecucion:
    def __init__(self, duracion_programa):
        self.duracion_programa = duracion_programa
        self.interrupciones = [] # este es un arreglo de tuplas para manejar T's con duraciones
        # print(self.duracion_programa)
    
    def anhadir_interrupcion(self, timestamp, irq, duracion): # Añadimos las interrupciones y ordenamos
        # Interrupciones: (Timestamp redondeado a 2 decimales | IRQ de la int. | duración (en seg.) de la int.)
        self.interrupciones.append((round(timestamp, 2), interrupciones[irq], duracion))
        self.interrupciones.sort(key=lambda int: int[0])

    def ver_resultado(self):
        pila = deque() # pila: [prioridad, t_restante]
        pila.append([999, self.duracion_programa, "Programa"])
        
        T = 0
        int_index = 0
        while len(pila) > 0 and int_index < len(self.interrupciones):
#             print(pila)
            actual = pila.pop()
            print(actual[2], end= " ")
            print("T=", T, end=" ")
#             print(actual, "")
            sig_T = self.interrupciones[int_index][0]
            sig_prio = self.interrupciones[int_index][1].prioridad
            sig_name = self.interrupciones[int_index][1].funcion
            sig_t_res = self.interrupciones[int_index][2]
            siguiente = [sig_prio, sig_t_res, sig_name]
            int_index += 1
            
            delta_T = sig_T - T
#             print("delta:", delta_T, end=" ")
            
            if actual[1] - delta_T <= 0:
            #→
                T += actual[1]
                print("T=", T)
                int_index -= 1
                continue
            
            actual[1] -= delta_T
            #→
            T += delta_T
            
            print("T=", T)
            
            # 1. Prio sig < actual → sig. "gana"
            if siguiente[0] < actual[0]:
                pila.append(actual)
                pila.append(siguiente)
            
            # 2. Prio sig > actual → actual "gana"
            if siguiente[0] > actual[0]:
                temp_q = deque()
                temp_q.append(actual)
                while pila[-1][0] < siguiente[0]:
                    temp_q.append(pila.pop())
                temp_q.append(siguiente)
                while temp_q:
                    pila.append(temp_q.pop())
#                 pila.append(siguiente)
#                 pila.append(actual)
            
        
        
        while len(pila) > 0:
            actual = pila.pop()
            print(actual[2], end= " ")
            print("T=", T, end=" ")
            T += actual[1]
            print("T=", T)


# Prueba 1 pre armada, con lo definido
prueba1 = Ejecucion(15)
prueba1.anhadir_interrupcion(3, 14, 5)
prueba1.anhadir_interrupcion(5, 9, 10)
prueba1.anhadir_interrupcion(10, 7, 8)
prueba1.anhadir_interrupcion(24, 14, 12)
prueba1.anhadir_interrupcion(42, 9, 5)
prueba1.interrupciones

prueba1.ver_resultado()