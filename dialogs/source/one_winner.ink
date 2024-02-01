~cambiar_expresion("happy2")
Y tenemos un ganador: “Damas y caballeros” o mejor dicho almas y demonios. # continue
~esperar(0.4)
~cambiar_expresion("sad")
Y eso que pensé que nunca terminaríamos.
Este fue un show emotivo pero va siendo hora de que caiga el telón. Ha sido… #continue
~esperar(0.1)
~cambiar_expresion("confused")
~esperar(0.25)
mm ¿Qué pasa?¿A tu premio? A si eso, lo lamento, mentí nunca hubo un premio, #continue
~cambiar_expresion("ups")
mi error “tehe”
Bueno, en realidad estaban aquí para ser castigados por sus errores y solo los dejé jugar ¿no? # continue
~cambiar_expresion("happy3")
Pero bueno, eventualmente volverás a participar y ni te darás cuenta. Después de todo el tiempo #continue
~reproducir_sonido("snap.wav", false)
~reproducir_sonido("puf.wav", false)
no es algo que nos preocupe aquí.

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