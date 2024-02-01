~cambiar_expresion("happy")
Hey, ya sé a quién no darle un arma. #continue
~esperar(0.2)
Y no se preocupen, ningún wisp fue tratado o maltratado cruelmente para este show…
~cambiar_expresion("ups")
Bueno, tal vez un poco, gajes del lugar. #continue
~esperar(0.2)
Aunque no somos tan malos como Disney o Nintendo. A veces mandamos a los nuevos reclutas a hacer sus pasantías ahí. Les sorprendería la cantidad de cosas que aprenden.

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