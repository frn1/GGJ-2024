Holis, voy a contar un chiste
{shuffle:
    - (Wow este es un chiste exelente) # continue
    - (Radamantis cuenta un chiste) # continue
    - (Un chiste extremadamente gracioso) # continue
}
~ cambiar_expresion("nada")
(Mucha risa) #continue
~ reproducir_sonido("laughing.wav", true)
Jajaja #continue
{cambiar_expresion("happy3")} 
mira como se rie el publico

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