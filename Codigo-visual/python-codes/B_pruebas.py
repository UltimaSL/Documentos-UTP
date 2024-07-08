class Interruption:
    def __init__(self, name, priority, start_time, duration):
        self.name = name
        self.priority = priority
        self.start_time = start_time
        self.duration = duration
        self.end_time = start_time + duration
        self.remaining_time = duration

def get_interruption_data():
    name = input("Ingrese el nombre de la interrupción (o 'fin' para terminar): ")
    if name.lower() == 'fin':
        return None
    start_time = int(input(f"Ingrese el tiempo en que ocurrirá la interrupción '{name}': "))
    duration = int(input(f"Ingrese la duración de la interrupción '{name}': "))
    return name, start_time, duration

def generate_interrupciones(interruptions, program_duration):
    interrupciones = []
    process_queue = []
    interruptions.sort(key=lambda x: (x.start_time, x.priority))
    
    current_time = 0
    total_execution_time = program_duration
    
    while interruptions:
        current_interruption = interruptions.pop(0)
        
        if current_time < current_interruption.start_time:
            interrupciones.append([current_time, current_interruption.start_time])
            current_time = current_interruption.start_time
        
        while current_interruption.remaining_time > 0:
            interrupciones.append([current_time, current_time + current_interruption.remaining_time, current_interruption.name])
            overlap_found = False

            for next_interruption in interruptions:
                if next_interruption.start_time < current_time + current_interruption.remaining_time and next_interruption.priority < current_interruption.priority:
                    overlap_found = True
                    interrupted_time = next_interruption.start_time - current_time
                    current_interruption.remaining_time -= interrupted_time
                    current_time = next_interruption.start_time

                    interrupciones.append([next_interruption.name, next_interruption.priority, current_interruption.name, current_interruption.name, current_time])
                    process_queue.append((current_interruption.name, interrupted_time))

                    interruptions.insert(0, current_interruption)
                    current_interruption = next_interruption
                    interruptions.remove(next_interruption)
                    break
            
            if not overlap_found:
                current_time += current_interruption.remaining_time
                current_interruption.remaining_time = 0
                interrupciones.append([current_interruption.start_time, current_time, current_interruption.name])
                process_queue.append((current_interruption.name, current_interruption.duration))
    
    if current_time < program_duration:
        interrupciones.append(f"Tiempo {current_time} a {program_duration}: Programa en ejecución.")
        total_execution_time += (program_duration - current_time)
        current_time = program_duration
    
    interrupciones.append(f"Tiempo total de ejecución: {total_execution_time} segundos.")
    return interrupciones, process_queue

def main():
    program_duration = int(input("Ingrese la duración total del programa en segundos: "))

    # Definir las prioridades de las interrupciones
    priorities = {
        "Programa": 0,
        "Reloj": 1,
        "Teclado": 2,
        "TICS": 3,
        "Red": 4,
        "PS-mouse": 7,
        "COPROC": 8,
        "Disco": 9,
        "COM2/4": 11,
        "COM1/3": 12,
        "Diskette": 14,
        "Impresora": 15,
    }

    interruptions = []
    while True:
        interruption_data = get_interruption_data()
        if not interruption_data:
            break
        name, start_time, duration = interruption_data
        priority = priorities.get(name, float('inf'))
        interruptions.append(Interruption(name, priority, start_time, duration))

    interrupciones, process_queue = generate_interrupciones(interruptions, program_duration)
    print("\nBitácora de interrupciones:")
    for entry in interrupciones:
        print(entry)

    print("\nCola de procesos:")
    for process in process_queue:
        name, executed_time = process
        print(f"Interrupción '{name}' se ejecutó durante {executed_time} segundos.")

if __name__ == "__main__":
    main()