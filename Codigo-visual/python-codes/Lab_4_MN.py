import math

#----------PRIMER PROBLEMA----------
#Metodo de intervalo medio
def intervalo_medio(f, a, b, tol=0.001, max_iter=1000):
    if f(a) * f(b) >= 0:
        print("La función no cambia de signo en el intervalo dado.")
        return None
    
    iteracion = 0
    error = 100
    while error > tol and iteracion < max_iter:
        c = (a + b) / 2
        error = round(abs(((b - a)/b)*100), 5)
        
        print(f"Iteración {iteracion + 1}: Intervalo [{a:.5f}, {b:.5f}], c = {c:.5f}, Error = {error:.5f}")
        
        if f(c) == 0:
            return c  # c es la raíz exacta
        elif f(a) * f(c) < 0:
            b = c
        else:
            a = c
        iteracion += 1
    
    return (a + b) / 2
#----------PRIMER PROBLEMA FIN----------

#----------SEGUNDO PROBLEMA----------
def p2(x):
    return x**2 * math.cos(x) - 5 * math.sin(x) + 3


#Metodo de regula falsi
def regula_falsi(f, a, b, T, tol=0.001, max_iter=1000):
    if f(a) * f(b) >= 0:
        print("La función no cambia de signo en el intervalo dado.")
        return None
    
    iteracion = 0
    fc=1.0
    
    while iteracion < max_iter:
        c = (a * f(b) - b * f(a)) / (f(b) - f(a))
        
        # Calcula el valor de t(c)
        fc = round(abs(f(c)), 5)
        
        print(f"Iteración {iteracion}: Intervalo [{a:.5f}, {b:.5f}], c = {c:.5f}, t(c) = {fc:.5f}")
        
        #Comprueba la precisión
        if abs(fc) < tol:
            return c
        # Actualiza el intervalo [a, b]
        if f(a) * fc < 0:
            b = c
        else:
            a = c
        
        iteracion += 1
    return None

#----------SEGUNDO PROBLEMA FIN----------

#----------TERCER PROBLEMA----------

# Definir la función f(t)
def funcion(t):
    return t**3 - 3*t**2 + 2*t + 1

# Definir la derivada de f(t)
def funcion_d(t):
    return 3*t**2 - 6*t + 2

#Metodo de Newton-Raphson
def newton_raphson(funcion, funcion_d, f0, tol=0, max_iter=1000):
    iteracion = 0
    error = 1.0
    while error > tol and iteracion < max_iter:
        next_val = f0 - funcion(f0) / funcion_d(f0) 
        error = round(abs(((next_val - f0)/next_val)*100), 5)
        
        f0 = next_val
        iteracion += 1
        print(f"Iteración {iteracion}: t = {f0:.5f}, Error = {error:.5f}")
    
    if iteracion == max_iter:
        print("El método no convergió después del máximo número de iteraciones.")
        return None
    
    return f0 #f0 referencia jejeje


#----------TERCER PROBLEMA FIN----------


#----------CUARTO PROBLEMA----------

# Definir la función R(t)
def funcion_sec(t):
    return 5 * math.exp(-t**2) * math.sin(t)

# Implementar el método de la Secante
def secante(funcion, f0, f1, tol=0.001, max_iter=1000):
    iteracion = 0
    while iteracion < max_iter:
        f_f0 = funcion(f0)
        f_f1 = funcion(f1)
        
        if abs(f_f1 - f_f0) < tol:
            print(f"Convergencia alcanzada en la iteración {iteracion+1}")
            return f1

        next_val = f1 - f_f1 * ((f1 - f0) / (f_f1 - f_f0))
        
        error = round(abs((next_val - f1) / next_val) * 100, 5)
        
        print(f"Iteración {iteracion+1}: f0 = {f0:.5f}, f1 = {f1:.5f}, next_val = {next_val:.5f}, Error = {error:.5f}")
        
        if error < tol:
            return next_val
        
        f0 = f1
        f1 = next_val
        iteracion += 1

#----------CUARTO PROBLEMA FIN----------



# Programa principal
def main():
    ciclo=True
        
    while ciclo==True:
        
        problema = int(input("Elija el numero problema a resolver:"
        "\nProblema 1 (Por intervalo medio)"
        "\nProblema 2 (Por regula falsi)"
        "\nProblema 3 (Por intervalo medio)"
        "\nProblema 4 (Por intervalo medio)"
        "\nSalir del Programa cualquier numero igual o mayor que 5\n"
        "\nSelecciones un numero:"))
        
        if problema == 1:
            #funcion a evaluar 
            f = lambda y: y**3 - 4*y + 1

            #Definir el intervalo inicial [a, b]
            a = 0
            b = 1

            #llamar a la funcion para calcular la raiz por intervalo medio
            raiz = intervalo_medio(f, a, b)

            if raiz is not None:
                print(f"La raíz aproximada es: {raiz:.5f}\n\n")
            else:
                print("No se encontró una raíz en el intervalo dado.\n\n")
            

        elif problema == 2:
            #Temperatura
            T = 7
            # Intervalo inicial [a, b]
            a = 0.5
            b = 1.0

            # Llamar a la función de regula falsi
            resultado = regula_falsi(p2, a, b, T)

            # Imprimir el resultado
            if resultado is not None:
                print(f"El valor de x que corresponde a T = {T} es aproximadamente: {resultado:.5f}\n\n")
            else:
                print("No se encontró una raíz en el intervalo dado.\n\n")
        elif problema == 3:
            raiz = newton_raphson(funcion, funcion_d, 1.0)
        
            # Imprimir el resultado
            if raiz is not None:
                print(f"El valor de t donde f(t) es cero es aproximadamente: {raiz:.5f}\n\n")
            else:
                print("No se encontró una raíz con el método de Newton-Raphson.\n\n")
            
        elif problema == 4:
                # Intervalo inicial [t0, t1] (elige valores cercanos donde crees que está la raíz)
                t0 = 0.5
                t1 = 1.0
                
                # Llamar al método de la Secante para encontrar la raíz de R(t) = 0
                raiz = secante(funcion_sec, t0, t1)
                
                # Imprimir el resultado
                if raiz is not None:
                    print(f"El valor de t donde R(t) es cero es aproximadamente: {raiz:.5f}\n\n")
                else:
                    print("No se encontró una raíz con el método de la Secante.\n\n")
        elif problema >= 5:
            ciclo = False
            
        else:
            print("Opción no válida.\n\n")

#pa que corra el programa, no se por que no corre sin esto :^(
if __name__ == "__main__":
    main()

