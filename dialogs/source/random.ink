{shuffle:
    - -> Random1
    - -> Random2
    - -> Random3
    - -> Random4
    - -> Random5
}

== Random1 ==
~cambiar_expresion("happy3")
Gran desempeño concursantes. #continue
~esperar(0.1)
~cambiar_expresion("intrigued2")
¿Cómo les va pareciendo? Por cierto no les comente que pasaría si ganaban ¿verdad?, #continue
~cambiar_expresion("happy")
el gran premio por el que todos compiten... o no.
~cambiar_expresion("intrigued")
¿Qué ganarán? #continue
~esperar(0.15)
~cambiar_expresion("happy3")
Spoiler: nada tan épico como un opening de anime de Attack of Titans. Pero tendrán la oportunidad de vivir su propia historia, ¡como un protagonista de Isekai como Re:Zero! #continue
~esperar(0.15)
~cambiar_expresion("ups")
El jabón viene de #continue
~reproducir_sonido("laughing.wav", false)
regalo.
-> DONE

== Random2 ==
~cambiar_expresion("happy")
Eso fue impresionante, #continue
~esperar(0.1)
~cambiar_expresion("intrigued2")
¿qué opina el público? ¿poco tiempo?, pero sabían que cuando estás en un show, la realidad es más fluida que la trama de un anime de filosofía existencial.
~cambiar_expresion("happy3")
Es como si estuvieras en otro mundo 
~cambiar_expresion("intrigued")
¿Qué es real? # continue
~esperar(0.15)
~cambiar_expresion("happy4")
La respuesta es tan esquiva como la verdad en 'Neon Genesis #continue
~reproducir_sonido("laughing.wav", false)
Evangelion'.
-> DONE

== Random3 ==
~cambiar_expresion("happy4")
¡Sí que le dieron duro a ese juego, como los pollos a Link en Ocarina of Time! #continue
~reproducir_sonido("cricri.wav", true)
 # continue
~cambiar_expresion("pokerface")
Vaya, sin risas. En serio, que público difícil. #continue
~esperar(0.2)
~cambiar_expresion("confused")
¿alguien con sentido del humor?
~cambiar_expresion("nada")
¡Pues tus chistes no!
~reproducir_sonido("RadaJoke.mp3", false)
~reproducir_sonido("laughing.wav", true)
~cambiar_expresion("happy4")
Jaja, está bien, actualizo mi opinión de querido público a cretinos.
~cambiar_expresion("happy2")
Anotación: primero, ir a trabajar mañana; segundo, despedir a Frank por el redoble; tercero, terminar de cortar el pasto, y esta vez no pasarlo para otro día.
-> DONE

== Random4 ==
~cambiar_expresion("happy")
Vaya la diversión de esta noche será eterna como este nivel infinito, el tiempo aquí es más elástico que las mecánicas de un juego de mundo abierto.
~cambiar_expresion("intrigued2")
¿Eternidad? #continue
~esperar(0.2)
~cambiar_expresion("happy3")
Sólo un término, #continue
~esperar(0.2)
~cambiar_expresion("angered")
como ‘lag’,  #continue
~esperar(0.1)
~cambiar_expresion("happy3")
que todos odiamos pero debemos aceptar.
-> DONE

== Random5 ==
~cambiar_expresion("happy3")
El éxito es tuyo, pero recuerda que la victoria es efímera como en este show. #continue
~cambiar_expresion("intrigued")
¿Podrás superar las pruebas venideras y mantener tu racha triunfal?
-> DONE

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