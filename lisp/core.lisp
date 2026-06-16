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

;; FUNCIÓN: informe (Extensión 2: Persistencia)
;; NATURALEZA: Impura (Genera y escribe de forma destructiva sobre un archivo de texto)
;; ESTRATEGIA: Recursiva de Cola (Tail Recursive) para iterar la lista de datos sin usar bucles imperativos
;; IMPACTO: No destructiva (No altera la lista original de entrada)
(defun informe (datos)
  (with-open-file (stream "informe-ejecucion-semaforo.txt" 
                          :direction :output 
                          :if-exists :superserve 
                          :if-does-not-exist :create)
    (format stream "Informe de Ejecución del Sistema Semafórico~%")
    (format stream "=========================================~%")
    (labels ((escribir-lineas (lista-datos)
               (when lista-datos
                 (let ((item (car lista-datos)))
                   ;; item esperado: (timestamp "ROJO" "VERDE")
                   (format stream "~A - Transición: ~A -> ~A~%" 
                           (first item) (second item) (third item))
                   (escribir-lineas (cdr lista-datos))))))
      (escribir-lineas datos))
    (format stream "--- Fin del Informe ---~%")))
