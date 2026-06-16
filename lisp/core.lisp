;; ========================================================
;; FUNCION: transicionV2
;;
;; NATURALEZA: Pura
;;             (No produce efectos secundarios. Para las
;;             mismas entradas siempre devuelve la misma salida)
;;
;; ESTRATEGIA: Funcion Predicado
;;             (Utiliza cond, and y eq para evaluar los
;;             estados actuales y determinar la transicion
;;             valida entre estados normales e intermitentes)
;;
;; IMPACTO: No destructiva
;;          (No modifica estructuras existentes. Construye
;;          y devuelve una nueva lista con el resultado)
;;
;; DESCRIPCION:
;;             Modela las transiciones del semaforo
;;             incorporando los estados de intermitencia:
;;             intermitente-rojo-verde,
;;             intermitente-verde-amarillo e
;;             intermitente-amarillo-rojo.
;;
;; ========================================================

(defun transicionV2 (color-actual cambiar-a)
(cond

	((and (eq color-actual 'en-rojo)
		  (eq cambiar-a 'intermitente-rojo-verde))
		(list color-actual "cambiar-a-intermitente-rojo-verde")
	)

	((and (eq color-actual 'intermitente-rojo-verde)
		  (eq cambiar-a 'verde))
		(list color-actual "cambiar-a-verde")
	)

	((and (eq color-actual 'en-verde)
		  (eq cambiar-a 'intermitente-verde-amarillo))
		(list color-actual "cambiar-a-intermitente-verde-amarillo")
	)

	((and (eq color-actual 'intermitente-verde-amarillo)
		  (eq cambiar-a 'amarillo))
		(list color-actual "cambiar-a-amarillo")
	)

	((and (eq color-actual 'en-amarillo)
		  (eq cambiar-a 'intermitente-amarillo-rojo))
		(list color-actual "cambiar-a-intermitente-amarillo-rojo")
	)

	((and (eq color-actual 'intermitente-amarillo-rojo)
		  (eq cambiar-a 'rojo))
		(list color-actual "cambiar-a-rojo")
	)

	(t
		(list color-actual 'accion-por-defecto)
	)
)) 

;; ======================================================== 
;; FUNCIÓN: cargar-configuracion 
;; NATURALEZA: Impura (lee las duraciones del semaforo desde
;; el archivo cl-json)
;; ESTRATEGIA: Función Simple 
;; IMPACTO: No destructiva 
;; ======================================================== 

(defun cargar-configuracion (archivo) 
	(with-open-file (stream archivo) 
	(cl-json:decode-json stream)))

;; ======================================================== 
;; FUNCIÓN: timer 
;; NATURALEZA: Pura (Dado el tiempo unix y las duraciones 
;; devuelve el estado en el que se encuentra el semaforo sin 
;; producir efectos secundarios)
;; ESTRATEGIA: Funcion Simple (utiliza cond y operaciones 
;; matematicas simples)
;; IMPACTO: No destructiva (no modifica ninguna estructura)
;; ======================================================== 

(defun calcular-timer (tiempoUnix rojo inter-rojo-verde 
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

;; ======================================================== 
;; FUNCIÓN: timer-desde-config 
;; NATURALEZA: Impura (lee y obtiene las duraciones desde el
;; archivo cl-json)
;; ESTRATEGIA: Función Simple 
;; IMPACTO: No destructiva 
;; ========================================================
(defun timer-desde-config (tiempoUnix archivo) 
  (let* ((config (cargar-configuracion archivo)) 
      
         (rojo (cdr (assoc :rojo config))) 
         (inter-rojo-verde (cdr (assoc :inter-rojo-verde config)))
         (verde (cdr (assoc :verde config))) 
         (inter-verde-amarillo (cdr (assoc :inter-verde-amarillo config))) 
         (amarillo (cdr (assoc :amarillo config))) 
         (inter-amarillo-rojo (cdr (assoc :inter-amarillo-rojo config)))) 
    
    (calcular-timer tiempoUnix 
    				rojo inter-rojo-verde 
    				verde inter-verde-amarillo 
    				amarillo inter-amarillo-rojo)))

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
