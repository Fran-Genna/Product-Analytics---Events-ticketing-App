# Product-Analytics---Events-ticketing-App (ESP)

## 🌟 Introducción
Este proyecto analiza un caso de **aumento del tráfico (+28%) pero caída de conversiones (-20%)** en una plataforma de venta de entradas para eventos musicales, utilizando **datos simulados** generados con Python (Pandas + Faker). El objetivo es identificar las causas principales del problema y proponer soluciones accionables para recuperar las conversiones perdidas.

### 🔍 Contexto
- **Problema**: A pesar de un aumento significativo del tráfico, la plataforma registró una **reducción del 20% en las conversiones** en 60 días.
- **Enfoque**: Análisis del **embudo de conversión**, sensibilidad al precio, problemas técnicos (post-31 de enero) y segmentación de usuarios.
- **Datos**: Simulados con distribuciones realistas para replicar un escenario real (ej.: sensibilidad al precio por género musical, comportamiento en app vs. web).

### 📈 Insights Clave
1. **Cuello de botella**: El **94% de los usuarios abandona** entre las fases **VER → PAGAR** (no en el checkout, que convierte >50%).
2. **Sensibilidad al precio**: Los géneros **Festival, Techno y Electrónica** muestran una conversión muy baja para entradas >40€.
3. **Problemas técnicos**: Aumento anómalo en los tiempos de checkout después del 31 de enero (posibles bugs o regresiones).
4. **Targeting**: La app genera el **70% del tráfico**, pero convierte menos que la web.

### 🛠️ Soluciones Propuestas
- **Pruebas A/B**: Precios y comunicación del valor para eventos >40€.
- **Fix técnicos**: Análisis de logs para identificar bugs en el checkout.
- **Retargeting**: Enfoque en segmentos VIP y optimización de campañas para géneros con alta sensibilidad al precio.

