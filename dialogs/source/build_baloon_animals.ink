~cambiar_expresion("happy2")
Oigan, son buenos para seguir órdenes, déjenme adivinar, ¿trabajaron en algún momento en atención al cliente? Si algo se especializa en ese oficio es en reducirte ante otros. A pesar de que a veces están completamente equivocados y te gritan por ello. Pero bueno, a servir a sus amos.
Mmm, renunciar y ser libre. Bueno, siempre habrá una nueva jaula o cadena que te ate. Por lo menos aquí ya reciben la verdadera libertad. No importa si los trajo el lobo o la cordera.
~esperar(0.4)
~cambiar_expresion("happy")
¿A qué me refiero con eso? Te lo explicaría, pero no lo entenderías ahora. Mejor no me hagas gastar mis palabras por nada, #continue
~esperar(0.1)
~cambiar_expresion("angered")
idiota. #continue
~esperar(0.1)
~cambiar_expresion("happy")
Continuemos.

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