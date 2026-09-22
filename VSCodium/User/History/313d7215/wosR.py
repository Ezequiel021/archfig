import numpy as np
def floattoieee(x: float, precision: int = 32) -> str:
    """
    Convierte un número flotante a su representación IEEE 754 en binario.

    Args:
        x: Número flotante a convertir
        precision: 32 o 64 bits

    Returns:
        String binario de 32 o 64 bits
    """
    # Configuración según precisión
    if precision == 32:
        l_exponente = 8
        l_mantisa = 23
        sesgo = 127
    elif precision == 64:
        l_exponente = 11
        l_mantisa = 52
        sesgo = 1023
    else:
        raise ValueError("La precisión debe ser 32 o 64 bits")

    # Ya sé que dice que no se deben considerar casos especiales, pero esto siempre me había picado la curiosidad xd
    # Casos especiales
    if np.isnan(x):
        if precision == 32:
            return "01111111110000000000000000000000"
        else:
            return "0111111111111000000000000000000000000000000000000000000000000000"

    if np.isinf(x):
        if x > 0:
            if precision == 32:
                return "01111111100000000000000000000000"
            else:
                return "0111111111110000000000000000000000000000000000000000000000000000"
        else:
            if precision == 32:
                return "11111111100000000000000000000000"
            else:
                return "1111111111110000000000000000000000000000000000000000000000000000"

    if x == 0:
        if precision == 32:
            return "00000000000000000000000000000000"
        else:
            return "0000000000000000000000000000000000000000000000000000000000000000"

    # Signo
    signo = '1' if x < 0 else '0'
    x = abs(x)

    # Separar parte entera y fraccionaria
    parte_entera = int(x)
    parte_fraccionaria = x - parte_entera

    # Convertir parte entera a binario
    if parte_entera == 0:
        bin_entera = '0'
    else:
        bin_entera = bin(parte_entera)[2:]

    # Convertir parte fraccionaria a binario (hasta tener suficientes bits)
    bin_fraccion = ''
    temp = parte_fraccionaria
    max_bits = l_mantisa + 1  # Un bit extra para el redondeo

    for _ in range(max_bits):
        temp *= 2
        if temp >= 1:
            bin_fraccion += '1'
            temp -= 1
        else:
            bin_fraccion += '0'

    # Normalizar: encontrar el exponente
    # El número es: 1.mantisa × 2^exponente
    if parte_entera > 0:
        # Caso normal: parte entera > 0
        exponente = len(bin_entera) - 1
        mantisa = (bin_entera[1:] + bin_fraccion)[:l_mantisa]
        # Redondeo (mirar el siguiente bit)
        siguiente_bit = (bin_entera[1:] + bin_fraccion)[l_mantisa:l_mantisa+1]
    else:
        # Caso subnormal: parte entera = 0
        # Encontrar el primer 1 en la parte fraccionaria
        try:
            primer_uno = bin_fraccion.index('1')
            exponente = -(primer_uno + 1)
            mantisa = bin_fraccion[primer_uno + 1:primer_uno + 1 + l_mantisa]
            # Asegurar que la mantisa tenga la longitud correcta
            mantisa = mantisa.ljust(l_mantisa, '0')
            siguiente_bit = bin_fraccion[primer_uno + 1 + l_mantisa:primer_uno + 2 + l_mantisa]
        except ValueError:
            # Esto no debería pasar si x != 0
            mantisa = '0' * l_mantisa
            exponente = -sesgo
            siguiente_bit = '0'

    # Redondeo al más cercano (redondear a la mitad hacia arriba)
    if siguiente_bit == '1':
        # Convertir mantisa a entero, sumar 1, volver a binario
        mantisa_int = int(mantisa, 2) if mantisa else 0
        mantisa_int += 1
        if mantisa_int >= 2 ** l_mantisa:
            # Overflow en la mantisa
            mantisa = '0' * l_mantisa
            exponente += 1
        else:
            mantisa = bin(mantisa_int)[2:].zfill(l_mantisa)

    # Verificar si el exponente está en rango
    if exponente + sesgo >= 2 ** l_exponente - 1:
        # Overflow: retornar infinito con el signo apropiado
        if precision == 32:
            return signo + "1111111100000000000000000000000"
        else:
            return signo + "111111111110000000000000000000000000000000000000000000000000000"

    if exponente + sesgo <= 0:
        # Subnormal o cero
        # Desnormalizar: shift derecho de la mantisa
        shift = 1 - (exponente + sesgo)
        if shift >= l_mantisa + 1:
            return signo + '0' * (precision - 1)  # Cero
        mantisa = ('1' + mantisa)[shift:shift + l_mantisa]
        mantisa = mantisa.ljust(l_mantisa, '0')
        exponente_bin = '0' * l_exponente
    else:
        # Caso normal
        exponente_bin = bin(exponente + sesgo)[2:].zfill(l_exponente)

    return signo + exponente_bin + mantisa[:l_mantisa]

# Pruebas
print(floattoieee(-5.0, 32))  # 11000000101000000000000000000000
print(floattoieee(-5.0, 64))  # 1100000000010100000000000000000000000000000000000000000000000000
