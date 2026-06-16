# TPI-Funcional-2026-Grupo36

## Integrantes
_Moreira Facundo Agustin_43346675
_Matias Juan Ezequiel Zacarias_43930603
_Juliana Maillen Riquelme Griffith_46395489
_Fabregat Malena Ayelen_40279603
_Ezequiel Benito Tomas Veloso_45650965

---

# Sistema de Semáforos Inteligentes

El objetivo del proyecto es modelar el comportamiento de un sistema semafórico utilizando programación funcional en Common Lisp, aplicando conceptos como funciones puras, composición funcional, inmutabilidad y procesamiento de datos.
Además, se implementó una extensión utilizando Quicklisp y la librería cl-json para cargar dinámicamente la configuración temporal de los semáforos desde un archivo JSON externo.

---

# Requisitos
Antes de ejecutar el proyecto es necesario contar con:
* Common Lisp (SBCL recomendado)
* Quicklisp
* Librería cl-json
Versión utilizada durante el desarrollo:
* SBCL 2.6.5
---

# Instalación
## 1. Instalar Quicklisp
Descargar Quicklisp:
curl -O https://beta.quicklisp.org/quicklisp.lisp

Iniciar SBCL:
sbcl

Instalar Quicklisp:

(load "quicklisp.lisp")
(quicklisp-quickstart:install)
(ql:add-to-init-file)

Reiniciar SBCL.

## 2. Instalar cl-json

Dentro de SBCL ejecutar:

(ql:quickload :cl-json)

---

# Estructura del Proyecto

TPI-Funcional-2026-Grupo36/
│
├── lisp/
│   ├── core.lisp
│   ├── config.json
│   └── informe-ejecucion-semaforo.txt
│
└── README.md

---

# Archivo de Configuración
El sistema carga automáticamente los tiempos de duración desde un archivo JSON externo.

Archivo:
{
  "rojo": 90,
  "inter-rojo-verde": 3,
  "verde": 120,
  "inter-verde-amarillo": 3,
  "amarillo": 6,
  "inter-amarillo-rojo": 3
}

Esto permite modificar los tiempos del semáforo sin necesidad de recompilar ni modificar el código fuente.
---

# Ejecución

Abrir SBCL y cargar la librería:

(ql:quickload :cl-json)

Cargar el proyecto:

(load "core.lisp")

---

# Requerimiento 1: Estados de Transición

Función:
(transicion color-actual cambiar-a)

## Uso normal
(transicion 'en-rojo 'verde)
Resultado:
(EN-ROJO "cambiar-a-verde")


(transicion 'en-verde 'amarillo)
Resultado:
(EN-VERDE "cambiar-a-amarillo")

## Camino alternativo

(transicion 'en-amarillo 'rojo)
Resultado:
(EN-AMARILLO "cambiar-a-rojo")

## Caso inválido
(transicion 'banana 'verde)
Resultado:
(BANANA ACCION-POR-DEFECTO)

---

# Requerimiento 2: Temporizador Automático

Función:

(timer tiempo-unix)

## Uso normal

(timer 10)

Resultado:
EN-ROJO

(timer 92)
Resultado:
INTERMITENTE-ROJO-VERDE

(timer 100)
Resultado:
EN-VERDE

## Caso alternativo
(timer 215)

Resultado:
INTERMITENTE-VERDE-AMARILLO

## Caso de error

(timer "hola")
Resultado:
TYPE-ERROR
---

# Requerimiento 3: Sistema de Auditoría

Función:
(registrar-cambio epoch color-anterior color-nuevo)

## Uso normal
(registrar-cambio
 1750000000
 'en-rojo
 'en-verde)

Salida:
Tiempo 1750000000: la luz ha cambiado de EN-ROJO a EN-VERDE

---

# Generación de Informe

Función:
(informe datos)

Ejemplo:
(informe
 '((1750000000 "ROJO" "VERDE")
   (1750000100 "VERDE" "AMARILLO")
   (1750000200 "AMARILLO" "ROJO")))

Resultado:
Se genera el archivo:
informe-ejecucion-semaforo.txt

---

# Requerimiento 4: Análisis de Ciclos

## Duración de Ciclo

Función:
(duracion-ciclo tiempos)

Ejemplo:
(duracion-ciclo
 '((:rojo . 90)
   (:amarillo . 6)
   (:verde . 120)))

Resultado:
216

## Recomendación

Función:
(recomendacion-ciclo duracion)

Ejemplo:
(recomendacion-ciclo 216)

Resultado:
"Duracion demasiado larga"

Ejemplo:
(recomendacion-ciclo 120)

Resultado:
"Duracion dentro del rango recomendado"

---

# Requerimiento 5: Ciclos por Tiempo

Función:
(ciclos-por-tiempo minutos tiempos)

Ejemplo:
(ciclos-por-tiempo
 15
 '((:rojo . 90)
   (:amarillo . 6)
   (:verde . 120)))

Resultado:
4

## Caso de error
(ciclos-por-tiempo
 10
 '((:rojo . "noventa")))

Resultado:
TYPE-ERROR

---

# Requerimiento 6: Distribución Temporal

Función:
(informe-distribucion-temporal tiempos)

Ejemplo:
(informe-distribucion-temporal
 '((:rojo . 90)
   (:amarillo . 6)
   (:verde . 120)))

Resultado aproximado:
((:ROJO 41.66)
 (:AMARILLO 2.77)
 (:VERDE 55.55))

---

# Extensión: Transiciones con Estados Intermitentes

Función:
(transicion-v2 color-actual cambiar-a)

Ejemplos:

(transicion-v2
 'en-rojo
 'intermitente-rojo-verde)
Resultado:
(EN-ROJO "cambiar-a-intermitente-rojo-verde")

(transicion-v2
 'intermitente-rojo-verde
 'verde)
Resultado:
(INTERMITENTE-ROJO-VERDE "cambiar-a-verde")

---

# Fase 2: Quicklisp y cl-json

Para la segunda fase del trabajo se integró la librería "cl-json". La misma permite cargar dinámicamente la configuración temporal del sistema desde un archivo JSON externo.

Beneficios:

* Separación entre configuración y código.
* Modificación de tiempos sin recompilar.
* Mayor flexibilidad para simulaciones.
* Cumplimiento del requisito de autonomía y ecosistema.

---

# Paradigmas Funcionales Aplicados

Durante el desarrollo se utilizaron los siguientes conceptos:

* Funciones puras.
* Inmutabilidad.
* Composición funcional.
* Procesamiento de listas.
* Recursión.
* Funciones de orden superior.
* Programación declarativa.

---

# Autoría

Trabajo Práctico Integrador – Programación Funcional – 2026.
6