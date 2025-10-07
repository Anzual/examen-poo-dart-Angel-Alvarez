import 'dart:async';
import 'dart:math';

abstract interface class Preparable {
  Future<void> preparar();
}

abstract interface class Imprimible {
  String obtenerDescripcion();
}

abstract class Bebida implements Preparable, Imprimible {
  final String nombre;
  final double precio;
  final int tiempoBaseSegundos;

  Bebida(this.nombre, this.precio, this.tiempoBaseSegundos);

  @override
  Future<void> preparar() async {
    print(
      '--> Empezando a preparar: $nombre (espera ${tiempoBaseSegundos}s)...',
    );
    await Future.delayed(Duration(seconds: tiempoBaseSegundos));
  }

  @override
  String obtenerDescripcion() {
    return '$nombre - \$${precio.toStringAsFixed(2)}';
  }
}

class Cafe extends Bebida {
  Cafe() : super('Café Americano', 2.50, 7);
  @override
  Future<void> preparar() async {
    print('>>> Moliendo granos y preparando $nombre...');
    await super.preparar();
    print('>>> $nombre listo. (Filtrado finalizado)');
  }
}

class Te extends Bebida {
  Te() : super('Té de Menta', 1.75, 4);
  @override
  Future<void> preparar() async {
    print('>>> Calentando agua para $nombre...');
    await Future.delayed(Duration(seconds: 2));
    await super.preparar();
    print('>>> $nombre listo. (Servido con limón)');
  }
}

class BatidoFrutas extends Bebida {
  BatidoFrutas() : super('Batido de Frutas', 4.00, 6);
  @override
  Future<void> preparar() async {
    print('>>> Seleccionando frutas y licuando para $nombre...');
    await Future.delayed(Duration(seconds: 2));
    await super.preparar();
    print('>>> $nombre listo. (Decorado con topping)');
  }
}

class Pedido {
  List<Bebida> items = [];
  String id;
  final _controlador = StreamController<String>();

  Pedido() : id = 'Orden: ${Random().nextInt(25) + 1}';
  Stream<String> get notificaciones => _controlador.stream;

  void agregarBebida(Bebida bebida) {
    items.add(bebida);
    print('Añadido al pedido ${this.id}: ${bebida.obtenerDescripcion()}');
  }

  Future<void> procesarPedido() async {
    print('\n===== Iniciando Pedido $id: ${items.length} Productos =====');
    _controlador.add('Iniciando preparación del pedido ${this.id}...');

    for (var bebida in items) {
      _controlador.add('Preparando ${bebida.nombre}...');
      await bebida.preparar();
      _controlador.add(' ${bebida.nombre} completado.');
    }

    _controlador.add('¡Pedido ${this.id} completado!');
    print('===== Pedido $id Finalizado =====');
    _controlador.close();
  }
}

void main() async {
  print('------ CAFETERÍA LA ROSA------');
  var cafe = Cafe();
  var te = Te();
  var batido = BatidoFrutas();
  var pedido = Pedido();
  pedido.agregarBebida(cafe);
  pedido.agregarBebida(te);
  pedido.agregarBebida(batido);

  pedido.notificaciones.listen((mensaje) {
    print('Notificación: $mensaje ');
  });

  await pedido.procesarPedido();
  print(
    '-------------------------------------\nProceso del pedido finalizado.',
  );
}
