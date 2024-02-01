~cambiar_expresion("pokerface")
Mmm, otro empate. #continue
~esperar(0.3)
~esperar("happy4")
Bueno como se prometió se reducirán los puntos, intenten no quedar en negativo y como dice él dicho Incluso el diablo siempre cumple su palabra o #continue
~esperar(0.15)
~esperar("confused")
¿algo así era?

EXTERNAL cambiar_expresion(nombre)
EXTERNAL esperar(tiempo)
EXTERNAL reproducir_sonido(nombre, esperar_a_que_termine)

// Estas existen para que se pueda probar sin el juego
=== function cambiar_expresion(nombre)
    [[Cambio de expresion: {nombre}]]

=== function esperar(tiempo)
    [[Pasa{tiempo != 1:n} {tiempo} segundo{tiempo != 1:s}]]

=== function reproducir_sonido(nombre, esperar_a_que_termine)
    [[Se escucha {nombre} y se {esperar_a_que_termine: espera a que termine|sigue ejecutando el resto del código}]]