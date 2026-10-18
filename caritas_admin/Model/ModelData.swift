import Foundation

// Datos de ejemplo solo para los #Preview; la app usa GET /causas y GET /admin/donors.

let casosEjemplo = [
    Caso(id: 1, clave: "CO", nombre: "Comedor Comunitario San Bernabé", nombreCorto: "Comedor",
         beneficiarios: "240 familias de la zona norte",
         objetivo: "Servir 1,200 comidas calientes por semana durante el segundo semestre de 2026 y sostener al equipo de cocina de la parroquia.",
         recaudado: 132400, meta: 180000, responsable: "Hna. Teresa Ibarra", lugar: "San Bernabé, Monterrey"),
    Caso(id: 2, clave: "BE", nombre: "Becas Escolares 2026", nombreCorto: "Becas",
         beneficiarios: "60 niñas y niños de primaria",
         objetivo: "Cubrir inscripción, uniformes y útiles del ciclo 2026-2027 para 60 estudiantes de familias en pobreza extrema.",
         recaudado: 71800, meta: 95000, responsable: "Lic. Andrés Cepeda", lugar: "Área metropolitana"),
    Caso(id: 3, clave: "DE", nombre: "Despensas de Emergencia", nombreCorto: "Despensas",
         beneficiarios: "Colonias afectadas por lluvias",
         objetivo: "Armar y entregar 2,000 despensas en las colonias afectadas por las lluvias de agosto en Juárez y Cadereyta.",
         recaudado: 96500, meta: 250000, responsable: "Ing. Paola Rangel", lugar: "Juárez y Cadereyta"),
    Caso(id: 4, clave: "CH", nombre: "Casa Hogar Santa Clara", nombreCorto: "Casa Hogar",
         beneficiarios: "38 adultos mayores",
         objetivo: "Sostener al imentación, medicamentos y cuidado de enfermería de 38 adultos mayores durante todo el año.",
         recaudado: 128900, meta: 140000, responsable: "Sra. Rosario Elizondo", lugar: "Guadalupe, N.L.")
]

let donantesEjemplo = [
    Donante(id: 1, nombre: "Sergio Alonso Treviño Garza", colonia: "Anáhuac", metodoPago: "SPEI",
            casoId: 4, casoClave: "CH", casoNombreCorto: "Casa Hogar", monto: 1000,
            ultimoDonativo: fechaDesdeAPI("2026-03-10T00:00:00"), riesgo: "Alto"),
    Donante(id: 2, nombre: "Alicia Montemayor de la Garza", colonia: "Obispado", metodoPago: "Efectivo",
            casoId: 1, casoClave: "CO", casoNombreCorto: "Comedor", monto: 800,
            ultimoDonativo: fechaDesdeAPI("2026-04-02T00:00:00"), riesgo: "Alto"),
    Donante(id: 3, nombre: "Jorge Alberto Ramírez Solís", colonia: "Cumbres", metodoPago: "SPEI",
            casoId: 3, casoClave: "DE", casoNombreCorto: "Despensas", monto: 1200,
            ultimoDonativo: fechaDesdeAPI("2026-05-12T00:00:00"), riesgo: "Alto"),
    Donante(id: 4, nombre: "Guadalupe Sánchez Cavazos", colonia: "Mitras Centro", metodoPago: "Efectivo",
            casoId: 2, casoClave: "BE", casoNombreCorto: "Becas", monto: 300,
            ultimoDonativo: fechaDesdeAPI("2026-06-28T00:00:00"), riesgo: "Medio"),
    Donante(id: 5, nombre: "Héctor Iván Cárdenas Lozano", colonia: "Escobedo", metodoPago: "SPEI",
            casoId: 3, casoClave: "DE", casoNombreCorto: "Despensas", monto: 450,
            ultimoDonativo: fechaDesdeAPI("2026-07-15T00:00:00"), riesgo: "Medio"),
    Donante(id: 6, nombre: "María Elena Guzmán Treviño", colonia: "Del Valle, San Pedro", metodoPago: "Efectivo",
            casoId: 1, casoClave: "CO", casoNombreCorto: "Comedor", monto: 500,
            ultimoDonativo: fechaDesdeAPI("2026-08-05T00:00:00"), riesgo: "Bajo"),
    Donante(id: 7, nombre: "Norma Leticia Fuentes Ayala", colonia: "Contry", metodoPago: "Efectivo",
            casoId: 2, casoClave: "BE", casoNombreCorto: "Becas", monto: 650,
            ultimoDonativo: fechaDesdeAPI("2026-08-18T00:00:00"), riesgo: "Bajo"),
    Donante(id: 8, nombre: "Rodrigo Villarreal Peña", colonia: "Valle Oriente", metodoPago: "SPEI",
            casoId: 4, casoClave: "CH", casoNombreCorto: "Casa Hogar", monto: 2500,
            ultimoDonativo: fechaDesdeAPI("2026-08-20T00:00:00"), riesgo: "Bajo")
]
