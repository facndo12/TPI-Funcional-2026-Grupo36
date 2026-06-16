;;; ========================================================
;;; Cargar dependencias
;;; ========================================================

(ql:quickload :cl-json)

;;; Permite redefinir TIMER sin conflicto con SBCL
(shadow 'timer)

;;; ========================================================
;;; REQUERIMIENTO 1
;;; TRANSICIÓN BÁSICA (SIN INTERMITENTES)
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: transicion
;;; NATURALEZA: Pura
;;; ESTRATEGIA: Condicional múltiple con validación
;;; IMPACTO: No destructiva
;;; ========================================================

(defun transicion (color-actual cambiar-a)

  (cond

    ((not (member color-actual
                  '(en-rojo en-amarillo en-verde)
                  :test #'eq))
     (list color-actual 'accion-por-defecto))

    ((eq cambiar-a 'rojo)
     (list color-actual "cambiar-a-rojo"))
    ((eq cambiar-a 'amarillo)
     (list color-actual "cambiar-a-amarillo"))
    ((eq cambiar-a 'verde)
     (list color-actual "cambiar-a-verde"))
    (t
     (list color-actual 'accion-por-defecto))))

;;; ========================================================
;;; REQUERIMIENTO 2
;;; TIMER BÁSICO (SIN INTERMITENTES)
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: timer-basico
;;; NATURALEZA: Pura
;;; ESTRATEGIA: Condicional múltiple
;;; IMPACTO: No destructiva
;;; ========================================================

(defun timer-basico (tiempo-unix)

  (let* ((rojo 90)
         (amarillo 6)
         (verde 120)
         (segundo
          (mod tiempo-unix
               (+ rojo amarillo verde))))
      (cond
      ((< segundo rojo)
       'en-rojo)
      ((< segundo (+ rojo verde))
       'en-verde)
      (t
       'en-amarillo))))

;;; ========================================================
;;; REQUERIMIENTO 3
;;; AUDITORÍA Y PERSISTENCIA
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: registrar-cambio
;;; NATURALEZA: Impura
;;; ESTRATEGIA: Salida por pantalla
;;; IMPACTO: No destructiva
;;; ========================================================

(defun registrar-cambio (epoch color-anterior color-nuevo)

  (format t
          "Tiempo ~D: la luz ha cambiado de ~A a ~A~%"
          epoch
          color-anterior
          color-nuevo))

;;; ========================================================
;;; FUNCIÓN: informe
;;; NATURALEZA: Impura
;;; ESTRATEGIA: Recursiva
;;; IMPACTO: No destructiva
;;; ========================================================

(defun informe (datos)

  (with-open-file
      (stream
       "informe-ejecucion-semaforo.txt"
       :direction :output
       :if-exists :supersede
       :if-does-not-exist :create)
    (format stream
            "Informe de Ejecución del Sistema Semafórico~%")
    (format stream
            "=========================================~%")
    (labels
        ((escribir-lineas (lista-datos)
           (when lista-datos
             (let ((item (car lista-datos)))
               (format stream
                       "~A - Transición: ~A -> ~A~%"
                       (first item)
                       (second item)
                       (third item))
               (escribir-lineas
                (cdr lista-datos))))))
      (escribir-lineas datos))
    (format stream
            "--- Fin del Informe ---~%")))
;;; ========================================================
;;; REQUERIMIENTO 4
;;; ANÁLISIS DE CICLOS
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: duracion-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: mapcar + reduce
;;; IMPACTO: No destructiva
;;; ========================================================

(defun duracion-ciclo (tiempos-alist)

  (if tiempos-alist
      (reduce #'+
              (mapcar #'cdr tiempos-alist))
      0))

;;; ========================================================
;;; FUNCIÓN: recomendacion-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: cond
;;; IMPACTO: No destructiva
;;; ========================================================

(defun recomendacion-ciclo (duracion)

  (cond
    ((< duracion 35)
     "Duracion demasiado corta")
    ((> duracion 150)
     "Duracion demasiado larga")
    (t
     "Duracion dentro del rango recomendado")))

;;; ========================================================
;;; REQUERIMIENTO 5
;;; PLANIFICACIÓN TEMPORAL
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: ciclos-por-tiempo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: truncate
;;; IMPACTO: No destructiva
;;; ========================================================

(defun ciclos-por-tiempo (minutos tiempos-alist)

  (truncate
   (* minutos 60)
   (duracion-ciclo tiempos-alist)))

;;; ========================================================
;;; REQUERIMIENTO 6
;;; DISTRIBUCIÓN TEMPORAL
;;; ========================================================

;;; ========================================================
;;; FUNCIÓN: informe-distribucion-temporal
;;; NATURALEZA: Pura
;;; ESTRATEGIA: mapcar
;;; IMPACTO: No destructiva
;;; ========================================================

(defun informe-distribucion-temporal (tiempos-alist)

  (let ((total
         (duracion-ciclo tiempos-alist)))
    (mapcar
     (lambda (estado)
       (list
        (car estado)
        (float
         (* (/ (cdr estado)
               total)
            100))))
     tiempos-alist)))

;;; ========================================================
;;; FASE 2
;;; CONFIGURACIÓN DINÁMICA CON JSON
;;; ========================================================

;;; ========================================================
;;; FUNCIONES AUXILIARES JSON
;;; ========================================================

(defun leer-archivo-completo (ruta)

  (with-open-file
      (stream ruta :direction :input)
    (let ((contenido
           (make-string
            (file-length stream))))
      (read-sequence contenido stream)
      contenido)))

(defun cargar-configuracion ()

  (json:decode-json-from-string

   (leer-archivo-completo
    "config.json")))

(defun obtener-tiempo (clave configuracion)
  (cdr
   (assoc clave configuracion)))

;;; ========================================================
;;; EXTENSIÓN
;;; TRANSICIONES CON INTERMITENTES
;;; ========================================================

;;; ========================================================
;;; FUNCION: transicion-v2
;;;
;;; NATURALEZA: Pura
;;; ESTRATEGIA: Función predicado
;;; IMPACTO: No destructiva
;;; ========================================================

(defun transicion-v2 (color-actual cambiar-a)
  (cond
    ((and (eq color-actual 'en-rojo)
          (eq cambiar-a 'intermitente-rojo-verde))
     (list color-actual
           "cambiar-a-intermitente-rojo-verde"))
    ((and (eq color-actual 'intermitente-rojo-verde)
          (eq cambiar-a 'verde))
     (list color-actual
           "cambiar-a-verde"))
    ((and (eq color-actual 'en-verde)
          (eq cambiar-a 'intermitente-verde-amarillo))
     (list color-actual
           "cambiar-a-intermitente-verde-amarillo"))
    ((and (eq color-actual 'intermitente-verde-amarillo)
          (eq cambiar-a 'amarillo))
     (list color-actual
           "cambiar-a-amarillo"))
    ((and (eq color-actual 'en-amarillo)
          (eq cambiar-a 'intermitente-amarillo-rojo))
     (list color-actual
           "cambiar-a-intermitente-amarillo-rojo"))
    ((and (eq color-actual 'intermitente-amarillo-rojo)
          (eq cambiar-a 'rojo))
     (list color-actual
           "cambiar-a-rojo"))
    (t
     (list color-actual
           'accion-por-defecto))))

;;; ========================================================
;;; FUNCIÓN: timer
;;; NATURALEZA: Pura
;;; ESTRATEGIA: Condicional múltiple
;;; IMPACTO: No destructiva
;;; ========================================================

(defun timer (tiempo-unix)

  (let* ((config
          (cargar-configuracion))
         (rojo
          (obtener-tiempo :rojo config))
         (inter-rojo-verde
          (obtener-tiempo
           :inter-rojo-verde
           config))
         (verde
          (obtener-tiempo :verde config))
         (inter-verde-amarillo
          (obtener-tiempo
           :inter-verde-amarillo
           config))
         (amarillo
          (obtener-tiempo
           :amarillo
           config))
         (inter-amarillo-rojo
          (obtener-tiempo
           :inter-amarillo-rojo
           config))
         (segundo
          (mod tiempo-unix

               (+ rojo
                  inter-rojo-verde
                  verde
                  inter-verde-amarillo
                  amarillo
                  inter-amarillo-rojo))))
    (cond
      ((< segundo rojo)
       'en-rojo)
      ((< segundo
           (+ rojo
              inter-rojo-verde))
       'intermitente-rojo-verde)
      ((< segundo
           (+ rojo
              inter-rojo-verde
              verde))
       'en-verde)
      ((< segundo
           (+ rojo
              inter-rojo-verde
              verde
              inter-verde-amarillo))
       'intermitente-verde-amarillo)
      ((< segundo
           (+ rojo
              inter-rojo-verde
              verde
              inter-verde-amarillo
              amarillo))
       'en-amarillo)
      (t
       'intermitente-amarillo-rojo))))