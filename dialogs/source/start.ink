~cambiar_expresion("happy")
¡Damas y caballeros, sean bienvenidos a 'Make me Laugh!', una velada que recordarán por las risas que resonarán en el aire. Están a punto de sumergirse en una experiencia única, repleta de carcajadas, música y momentos que grabaré en sus memorias. 
Prepárense para ser testigos de un espectáculo que no solo hará que se re desvanezcan de risa, sino que también les brindará una experiencia única que trasciende el tiempo ¿Listos para un viaje donde la elegancia resalta y donde mi entretenimiento es lo más importante?
~cambiar_expresion("happy3")
Permítanme agradecerles por ser parte de esta reunión mágica, donde la risa es la llave maestra que abre las puertas de mi felicidad.
~esperar(0.2)
~cambiar_expresion("happy2")
Y ahora, sin más preámbulos, les presento a la joya de la noche, su servidor, el magnífico Rada. En esta travesía, mi elegancia, sabiduría, carisma y buen humor serán la guía para llevar sus risas a nuevas alturas. ¡Que comience 'Make me Laugh!', donde la risa es la regla y el juicio recae en la destreza de mis concursantes.
~esperar(1.0)
¡Y para mis jugadores! Soy Radamantis, Rada para la plebe, la estrella con más estilo. #continue
~cambiar_expresion("intrigued")
¿Listos para una noche de juegos que son tan inesperados como un giro de trama en un juego de Hideo Kojima? #continue
~ reproducir_sonido("applause.wav", false)
~ esperar(0.25)
¡Comenzamos los juegos!

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