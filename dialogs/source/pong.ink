~cambiar_expresion("happy")
Genial eso si fue un encuentro explosivo. Aunque no tanto como yo. #continue
~esperar(0.2)
~cambiar_expresion("intrigued")
¿Cómo se sienten? #continue
~esperar(0.4)
~cambiar_expresion("happy4")
Nada te desestresa más que un combate mortal. #continue
Siempre digo que no hay nada mejor que un combate de explosivos aunque a veces haya tontos que se confunden y traen cuchillos.
~cambiar_expresion("intrigued")
Graciosamente a dos participantes le funcionó, desde entonces un superior me grita “¡Son expertos Rada, expertos!”.

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