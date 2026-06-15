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

; ========================================================
;; FUNCION: registrarCambio
;;
;; NATURALEZA: Impura - (Produce efectos secundarios de entrada/salida. Altera
;;             la terminal al imprimir texto en pantalla y
;;             retorna siempre el valor NIL)
;;
;; ESTRATEGIA: Evaluacion Secuencial de Salida - (Utiliza format
;;             para procesar y mostrar los datos ordenadamente)
;;
;; IMPACTO: No destructiva - (No modifica variables ni altera estructuras en
;;          memoria)
;; ========================================================
(defun registrarCambio (epoch colorAnterior colorNuevo)
  (format t "Tiempo ~ D: la luz ha cambiado de ~A a ~A ~%" 
          epoch 
          colorAnterior 
          colorNuevo))
