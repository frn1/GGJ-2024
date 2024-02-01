~cambiar_expresion("happy")
Y para ustedes mi querido público hemos llegado al final de este show, pero que no digan que las risas no faltaron. Los estaré esperando para nuestro próximo show. 
~cambiar_expresion("happy3")
Aquí estará siempre su hermoso, inteligente, sexy presentador #continue
~ reproducir_sonido("applause.wav", false)
favorito en todos los círculos del infierno para animarlos.

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