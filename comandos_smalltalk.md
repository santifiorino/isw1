# Comandos SmallTalk

## Ordered Collections

### Preguntar su tamaño

```smalltalk
aCollection size
```

### Agregar un objeto

```smalltalk
aCollection add: anObject
```

### Agregar todos los objetos de una collection a otra

```smalltalk
aCollection addAll: anotherCollection
```

### Sacar un objeto

Saca la primera aparicion del objeto de la collection. Tira error si el objeto no está, al menos que uses el "ifAbsent" para que haga lo que vos quieras.

```smalltalk
aCollection remove: anObject ifAbsent: [aClosure]
```

### Sacar todas las apariciones de un objeto

Saca todas las apariciones del objeto de la collection. Tira error si el objeto no está, al menos que uses el "ifAbsent" para que haga lo que vos quieras.

```smalltalk
aCollection remove: anObject ifAbsent: [aClosure]
```

### Preguntar si tiene un objeto

Retorna un booleano indicando si la collection tiene el objeto.

```smalltalk
aCollection includes: anObject
```

### Filtrar objetos que cumplan con una condición

Retorna una nueva collection con los objetis que cumplen la condicion.

```smalltalk
aCollection select: [:anObject | anObject condition]
```

### Buscar objeto que cumpla con una condición

Retorna el primer objeto de la collection que cumpla la condición. Tira error si ningún objeto la cumple, al menos que uses el "ifNone" para que haga lo que vos quieras.

```smalltalk
aCollection detect: [:anObject | anObject condition] ifNone: [aClosure]
```

### Hacer algo con cada objeto

Retorna una nueva collection con lo que retornan los objetos al mandarles un mensaje.

```smalltalk
aCollection collect: [:anObject | anObject aMessage]
```

### Ver si todos los objetos cumplen una condición

Retorna un booleano indicando si todos la cumplen.

```smalltalk
aCollection allSatisfy: [:anObject | anObject condition]
```

### Ver si algún objeto cumplen una condición

Retorna un booleano indicando si alguno la cumple.

```smalltalk
aCollection anySatisfy: [:anObject | anObject condition]
```

### Sumatoria de sus objetos

Retorna la sumatoria de todos los objetos. Tira error si la collection está vacía, al menos que uses el "ifEmpty" para que haga lo que vos quieras.

```smalltalk
aCollection sum: #yourself ifEmpty: [somethingToReturn]
```

Hay otra alternativa si no querés sumar los objetos en sí, sino algo que retornen al mandarles un mensaje.

```smalltalk
aCollection sum: [:anObject | anObject aMessage] ifEmpty: [somethingToReturn]
```

### Iterar sobre sus elementos

```smalltalk
aCollection do: [:anObject | "doSomethingHere"]
```

### Flatten

Retorna una collection (1 dimensión), con todos los elementos de una collection de collections (2 o más dimensiones).

```smalltalk
a2DCollection flatten
```
