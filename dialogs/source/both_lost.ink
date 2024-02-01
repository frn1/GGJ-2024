~cambiar_expresion("sadfake")
Parece que se acabaron las chances amigos.  # continue
~esperar(0.5)
~cambiar_expresion("happy3")
~reproducir_sonido("snap.wav", false)
~reproducir_sonido("puf.wav", false)
Lo lamento pero suerte para la próxima

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