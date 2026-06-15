;; ======================================================== 
;; FUNCIÓN: timer 
;; NATURALEZA: Pura (Dado el tiempo unix y las duraciones 
;; devuelve el estado en el que se encuentra el semaforo sin 
;; producir efectos secundarios)
;; ESTRATEGIA: Funcion Simple (utiliza cond y operaciones 
;; matematicas simples)
;; IMPACTO: No destructiva (no modifica ninguna estructura)
;; ======================================================== 
(defun timer (tiempoUnix rojo inter-rojo-verde 
				verde inter-verde-amarillo 
				amarillo inter-amarillo-rojo)

	(let ((segundo
				(mod tiempoUnix (+ rojo inter-rojo-verde 
								verde inter-verde-amarillo amarillo 
								inter-amarillo-rojo))))

	(cond 
		((< segundo rojo) 'en-rojo)

		((< segundo (+ rojo inter-rojo-verde))
				'intermitente-rojo-verde)

		((< segundo (+ rojo inter-rojo-verde verde))
				'en-verde)
		((< segundo (+ rojo inter-rojo-verde 
					verde inter-verde-amarillo))
				'intermitente-verde-amarillo)

		((< segundo (+ rojo inter-rojo-verde verde 
					inter-verde-amarillo amarillo))
				'en-amarillo)

		(t 'intermitente-amarillo-rojo)
	)))
