import numpy as np

# Definición de las funciones del problema 1 en un solo array
def funcs_p1(x):
    return np.array([x[0]**2 + x[1] - 5, np.exp(x[0]) + np.sin(x[1]) - 3])

# Definición de la matriz Jacobiana del problema 1
def jacobian_p1(x):
    j11 = 2 * x[0]
    j12 = 1
    j21 = np.exp(x[0])
    j22 = np.cos(x[1])
    return np.array([[j11, j12], [j21, j22]])

# Definición de las funciones del problema 2 en un solo array
def funcs_p2(x):
    return np.array([x[0]**2 + x[1]**2 + x[2]**2 - 6, np.exp(x[0]) + x[1]*x[2] - 4, x[0] + x[1] + x[2] - 3])

# Definición de la matriz Jacobiana del problema 2
def jacobian_p2(x):
    j11 = 2 * x[0]
    j12 = 2 * x[1]
    j13 = 2 * x[2]
    j21 = np.exp(x[0])
    j22 = x[2]
    j23 = x[1]
    j31 = 1
    j32 = 1
    j33 = 1
    return np.array([[j11, j12, j13], [j21, j22, j23], [j31, j32, j33]])

# Método de Newton genérico con impresión de cada iteración
def newton_method(funcs, jacobian, x0, tol=1e-3, max_iter=1000):
    x = np.array(x0, dtype=float)  # Convertir la aproximación inicial a un array de tipo float
    for i in range(max_iter):
        J = jacobian(x)  # Calcular la matriz Jacobiana en el punto actual
        F = funcs(x)  # Evaluar todas las funciones en el punto actual
        delta = np.linalg.solve(J, -F)  # Resolver el sistema de ecuaciones lineales J * delta = -F
        x += delta  # Actualizar la aproximación
        error = np.linalg.norm(delta)
        print(f"Iteración {i + 1}: x = {x}, error = {error}")
        if error < tol:  # Comprobar si la solución ha convergido
            return x
    raise ValueError("No convergió en el número máximo de iteraciones")

# Menú de selección de problema
def main():
    ciclo = True
        
    while ciclo:
        problema = int(input("Elija el número de problema a resolver:"
            "\n1 - Problema 1"
            "\n2 - Problema 2"
            "\n3 o mayor - Salir del programa\n"
            "\nSeleccione un número: "))
            
        if problema == 1:
            funcs = funcs_p1
            jacobian = jacobian_p1
            x0 = [1.0, 1.0]
            
        elif problema == 2:
            funcs = funcs_p2
            jacobian = jacobian_p2
            x0 = [1.0, 1.0, 1.0]
            
        elif problema >= 3:
            ciclo = False
                
        else:
            print("Opción no válida.\n\n")

        if problema == 1 or problema == 2:
            try:
                solucion = newton_method(funcs, jacobian, x0)
                print(f"\nLa solución es {solucion}\n")
            except ValueError as e:
                print(e)
                print("Intenta con otra aproximación inicial")

if __name__ == "__main__":
    main()
