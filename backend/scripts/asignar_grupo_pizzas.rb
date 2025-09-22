# Script para asignar grupo a todas las pizzas tradicionales y especiales existentes

tradicional = Grupo.find_by(nombre: 'Pizzas Tradicionales')
especial = Grupo.find_by(nombre: 'Pizzas Especiales')

PizzaTradicional.update_all(grupo_id: tradicional.id) if tradicional
PizzaEspecial.update_all(grupo_id: especial.id) if especial

puts "Grupos asignados correctamente a todas las pizzas."
