import numpy as np
import sympy as sp

def input_functions(n):
    functions = []
    for i in range(n):
        while True:
            try:
                func_str = input(f"Introduce la función f_{i+1}(x1, ..., xn): ")
                # Usar sympy para convertir la cadena de entrada en una función de sympy
                x = sp.symbols(f'x:{n}')
                func_sympy = sp.sympify(func_str)
                func_lambda = sp.lambdify(x, func_sympy, 'numpy')
                functions.append(func_lambda)
                break
            except Exception as e:
                print(f"Error en la función introducida: {e}. Por favor, intenta de nuevo.")
    return functions

def evaluate_functions(functions, x):
    return np.array([func(*x) for func in functions], dtype=float)

def jacobian_matrix(functions, x, h=1e-8):
    n = len(x)
    J = np.zeros((n, n))
    for i in range(n):
        x_h = np.copy(x)
        x_h[i] += h
        f_x_h = evaluate_functions(functions, x_h)
        f_x = evaluate_functions(functions, x)
        J[:, i] = (f_x_h - f_x) / h
    return J

def newton_method_general(functions, x0, tol=1e-5, max_iter=100):
    x = np.array(x0, dtype=float)
    print(f"{'Iteración':<10}{'x':<20}{'Δx':<20}{'Error Relativo (%)':<20}")
    for k in range(max_iter):
        Fx = evaluate_functions(functions, x)
        Jx = jacobian_matrix(functions, x)
        try:
            Jx_inv = np.linalg.inv(Jx)
        except np.linalg.LinAlgError:
            print("La matriz Jacobiana es singular y no se puede invertir.")
            return x
        
        delta_x = -Jx_inv @ Fx
        x_new = x + delta_x
        error_relativo = np.linalg.norm(delta_x / (x + 1e-10)) * 100  # Evitar división por cero
        print(f"{k:<10}{x[0]:<20.10f}{delta_x[0]:<20.10f}{error_relativo:<20.10f}")
        x = x_new
        if error_relativo < tol:
            break
    return x

def main():
    n = int(input("Introduce el número de ecuaciones y variables: "))
    functions = input_functions(n)
    x0 = [float(input(f"Introduce el valor inicial para x{i+1}: ")) for i in range(n)]
    
    solution = newton_method_general(functions, x0)
    print("Solución:", solution)

if __name__ == "__main__":
    main()

