import numpy as np

#problem 1
def problema1(x):
    return np.array([x[0]**2 + x[1] - 5, np.exp(x[0]) + np.sin(x[1]) - 3])

#problem 1 matriz jacobiana
def m_jacobiana_p1(x):
    return np.array([[2 * x[0], 1], [np.exp(x[0]), np.cos(x[1])]])

#problem 2
def problema2(x):
    return np.array([x[0]**2 + x[1]**2 + x[2]**2 - 6, np.exp(x[0]) + x[1]*x[2] - 4, x[0] + x[1] + x[2] - 3])

#problem 2 matriz jacobiana
def m_jacobiana_p2(x):
    return np.array([[2 * x[0], 2 * x[1], 2 * x[2]], [np.exp(x[0]), x[2], x[1]], [1, 1, 1]])

def newton_method(ecuacion, jacobian, x0, tol=1e-3, max_iter=1000):
    x = np.array(x0, dtype=float)  # Convertir la aproximación inicial a un array de tipo float
    for i in range(max_iter):
        matriz_j = jacobian(x)  #calcular la matriz Jacobiana en la x actual
        f = ecuacion(x)  #evalua todas las funciones en la x actual
        delta = np.linalg.solve(matriz_j, -f)  #resolver el sistema de ecuaciones
        x += delta  #actualizar la aproximación
        error = np.linalg.norm(delta) #calcular el error (btw numpy es lo maximo)
        print(f"Iteración {i + 1}: x = {x}, error = {error}")
        if error < tol:  # Comprobar si la solución ha convergido
            return x
        elif error<1 and i>950:
            print("No converge en el número máximo de iteraciones")
            print(f"pero estos son los valore más proximos")
            return x
    if error>tol:
        print("No convergió en el número máximo de iteraciones")

# Menú de selección de problema
def main():
    ciclo = True
        
    while ciclo:
        problema = int(input("Elija el número de problema a resolver:"
            "\n1 Presiona 1 para el Problema 1"
            "\n2 Presiona 2 para el Problema 2"
            "\n3 Presiona 3 o un nuero mayor para salir del programa\n"
            "\nSeleccione un número: "))
            
        if problema == 1:
            ecuacion = problema1
            jacobian = m_jacobiana_p1
            x0 = [1.0, 1.0]
            
        elif problema == 2:
            ecuacion = problema2
            jacobian = m_jacobiana_p2
            x0 = [1, 1, 2]  # Ajustar la aproximación inicial
            
        elif problema >= 3:
            ciclo = False
                
        else:
            print("Opción no válida.\n\n")

        if problema == 1 or problema == 2:
            try:
                solucion = newton_method(ecuacion, jacobian, x0)
                print(f"\nlos valor obtenidos son: {solucion}\n")
            except ValueError as e:
                print(e)
                print("Intenta con otra aproximación inicial") #por si quiere cambiar los valores iniciales

if __name__ == "__main__":
    main()
