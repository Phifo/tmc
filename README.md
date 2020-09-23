# Tasa de Interés Máxima Convencional

API para obtener la tasa de interés máxima convencional a partir del monto del crédito, plazo del crédito y fecha en que se quiere obtener el interés.

## Production
El endpoint se puede utilizar por medio de una consulta GET a `http://ec2-34-203-204-23.compute-1.amazonaws.com/api/v1/tmc` y se debe consultar con los siguientes _query params_.
* loan_amount (en UF)
* loan_term (en meses)
* date (formato YYYY-MM-DD)

### Ejemplo
Ejemplo de consulta con un monto de crédito de 350 UF, plazo del crédito de 60 meses y fecha 2020-08-03
```bash
curl http://ec2-34-203-204-23.compute-1.amazonaws.com/api/v1/tmc?loan_amount=350&loan_term=60&date=2020-08-03
```
Ejemplo de respuesta JSON
```json
{
    "loan_amount": 350.0,
    "loan_term": 60,
    "date": "2020-08-03",
    "tmc": 18.84
}
```


## Development
La aplicación está dockerizada por lo que solo se necesita utilizar docker-compose para poder ejecutarla

```bash
docker-compose build
docker-compose up
```

La aplicación quedará disponible en `http://localhost:3000/api/v1/tmc`

En caso de no tener instalado Docker se debe seguir los pasos estándar para ejecutar una aplicación en Ruby on Rails con Ruby 2.3.1 y MySQL 5.7.16

## Tests
Primero crear base de datos en caso de que no exista
```bash
docker-compose run --rm web rails db:create
```
Correr tests
```bash
docker-compose run --rm web rspec
```

## Supuestos
En este proyecto está el supuesto de utilizar operaciones no reajustables en moneda nacional
