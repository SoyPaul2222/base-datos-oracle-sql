# 🏀 Gestión de Estadísticas de la NBA - Oracle SQL & PL/SQL

Este repositorio contiene un proyecto integral de base de datos desarrollado en Oracle SQL y PL/SQL para gestionar toda la estructura, datos y lógica de negocio de la NBA. El proyecto abarca desde el modelado relacional de conferencias, divisiones, equipos y jugadores, hasta la programación avanzada en el servidor mediante componentes específicos de PL/SQL.

---

## 🛠️ Tecnologías y Herramientas
* **Motor de Base de Datos:** Oracle Database (compatible con SQL*Plus / Oracle SQL Developer).
* **Lenguajes:** SQL (DDL / DML) y PL/SQL Avanzado.

---

## 📁 Estructura del Repositorio

El proyecto está modularizado de forma limpia según el tipo de componente técnico implementado:

### 1. 🏗️ Estructura Base y Datos
* **`nba_oracle_creates.sql`:** Definición del modelo relacional completo (DDL). Creación de tablas con sus respectivas claves primarias (`PK`), ajenas (`FK`) y restricciones (`CHECK`) para asegurar la integridad de ligas, conferencias, divisiones, equipos, jugadores y estadísticas.
* **`nba_oracle_inserts.sql`:** Set de datos masivo (DML) con registros históricos reales de la NBA para poblar el sistema y permitir la simulación de consultas de rendimiento.

### 2. ⚙️ Lógica de Negocio y Automatización (PL/SQL)
* **`Cursores.sql`:** Implementación de estructuras de control y cursores avanzados para recorrer, procesar y formatear conjuntos de datos fila por fila (ideal para reportes masivos de estadísticas).
* **`Funciones.sql`:** Desarrollo de bloques de código estructurados para realizar cálculos dinámicos repetitivos, como medias de puntos, rebotes, asistencias o minutos por partido de un jugador.
* **`Procedimientos.sql`:** Stored Procedures diseñados para automatizar operaciones complejas del sistema y formatear listados estructurados de rendimiento por jugador o franquicia.
* **`Triggers.sql`:** Disparadores encargados de la seguridad activa de la base de datos, controlando de forma automática las restricciones de integridad y validando las reglas de negocio en tiempo real durante las inserciones o modificaciones.
