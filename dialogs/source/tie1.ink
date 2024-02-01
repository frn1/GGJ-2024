~cambiar_expresion("confused")
¿Un empate? # continue
~esperar(0.4)
~cambiar_expresion("sad")
Eso no es para nada divertido.
~cambiar_expresion("angered")
Vamos, ¿no pueden hacer algo mejor que eso? Solo les advierto, si persisten en empatar, les restará puntos a ambos. Y que quede claro, el precio por perder de esa manera es muy elevado.

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