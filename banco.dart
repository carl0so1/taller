import 'dart:io';

class Cliente {
  String identificacion;
  String nombreCompleto;
  String correoElectronico;

  Cliente(this.identificacion, this.nombreCompleto, this.correoElectronico);
}

class CuentaAhorro {
  String codigo;
  DateTime fechaCreacion;
  double saldo;
  Cliente cliente;

  CuentaAhorro(this.codigo, this.cliente)
      : fechaCreacion = DateTime.now(),
        saldo = 0.0;

  void consignar(double monto) {
    saldo += monto;
  }

  bool retirar(double monto) {
    if (saldo >= monto) {
      saldo -= monto;
      return true;
    }
    return false;
  }
}

class Banco {
  List<CuentaAhorro> cuentas = [];
  int consecutivo = 1;

  CuentaAhorro crearCuenta(Cliente cliente) {
    String codigo = generarCodigo();
    CuentaAhorro cuenta = CuentaAhorro(codigo, cliente);
    cuentas.add(cuenta);
    return cuenta;
  }

  bool consignar(String codigo, double monto) {
    CuentaAhorro? cuenta = consultarCuenta(codigo);
    if (cuenta != null) {
      cuenta.consignar(monto);
      return true;
    }
    return false;
  }

  bool retirar(String codigo, double monto) {
    CuentaAhorro? cuenta = consultarCuenta(codigo);
    if (cuenta != null) {
      return cuenta.retirar(monto);
    }
    return false;
  }

  CuentaAhorro? consultarCuenta(String codigo) {
    return cuentas.firstWhere((cuenta) => cuenta.codigo == codigo,
        orElse: () => null as CuentaAhorro);
  }

  List<CuentaAhorro> listarCuentas() {
    return cuentas;
  }

  String generarCodigo() {
    int year = DateTime.now().year;
    String codigo = '$year-$consecutivo';
    consecutivo++;
    return codigo;
  }
}

void main() {
  Banco banco = Banco();

  while (true) {
    print('\nMENÚ BANCO ADSO 2874057');
    print('1. Crear Cuenta');
    print('2. Consignar Cuenta');
    print('3. Retirar Cuenta');
    print('4. Consultar Cuenta Por Código');
    print('5. Listar Cuentas');
    print('6. Salir');
    stdout.write('Ingrese Opción (1-6): ');
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case '1':
        crearCuenta(banco);
        break;
      case '2':
        consignarCuenta(banco);
        break;
      case '3':
        retirarCuenta(banco);
        break;
      case '4':
        consultarCuenta(banco);
        break;
      case '5':
        listarCuentas(banco);
        break;
      case '6':
        print('Gracias por usar el sistema. ¡Hasta luego!');
        return;
      default:
        print('Opción no válida. Por favor, intente de nuevo.');
    }
  }
}

void crearCuenta(Banco banco) {
  stdout.write('Ingrese la identificación del cliente: ');
  String? identificacion = stdin.readLineSync();
  stdout.write('Ingrese el nombre completo del cliente: ');
  String? nombreCompleto = stdin.readLineSync();
  stdout.write('Ingrese el correo electrónico del cliente: ');
  String? correoElectronico = stdin.readLineSync();

  if (identificacion != null &&
      nombreCompleto != null &&
      correoElectronico != null) {
    Cliente cliente =
        Cliente(identificacion, nombreCompleto, correoElectronico);
    CuentaAhorro cuenta = banco.crearCuenta(cliente);
    print('Cuenta creada con éxito. Código: ${cuenta.codigo}');
  } else {
    print('Error: Todos los campos son obligatorios.');
  }
}

void consignarCuenta(Banco banco) {
  stdout.write('Ingrese el código de la cuenta: ');
  String? codigo = stdin.readLineSync();
  stdout.write('Ingrese el monto a consignar: ');
  String? montoStr = stdin.readLineSync();

  if (codigo != null && montoStr != null) {
    double? monto = double.tryParse(montoStr);
    if (monto != null) {
      bool resultado = banco.consignar(codigo, monto);
      if (resultado) {
        print('Consignación realizada con éxito.');
      } else {
        print(
            'Error: No se pudo realizar la consignación. Verifique el código de la cuenta.');
      }
    } else {
      print('Error: Monto inválido.');
    }
  } else {
    print('Error: Código de cuenta y monto son obligatorios.');
  }
}

void retirarCuenta(Banco banco) {
  stdout.write('Ingrese el código de la cuenta: ');
  String? codigo = stdin.readLineSync();
  stdout.write('Ingrese el monto a retirar: ');
  String? montoStr = stdin.readLineSync();

  if (codigo != null && montoStr != null) {
    double? monto = double.tryParse(montoStr);
    if (monto != null) {
      bool resultado = banco.retirar(codigo, monto);
      if (resultado) {
        print('Retiro realizado con éxito.');
      } else {
        print(
            'Error: No se pudo realizar el retiro. Verifique el código de la cuenta y el saldo disponible.');
      }
    } else {
      print('Error: Monto inválido.');
    }
  } else {
    print('Error: Código de cuenta y monto son obligatorios.');
  }
}

void consultarCuenta(Banco banco) {
  stdout.write('Ingrese el código de la cuenta: ');
  String? codigo = stdin.readLineSync();

  if (codigo != null) {
    CuentaAhorro? cuenta = banco.consultarCuenta(codigo);
    if (cuenta != null) {
      print('Información de la cuenta:');
      print('Código: ${cuenta.codigo}');
      print('Fecha de creación: ${cuenta.fechaCreacion}');
      print('Saldo: ${cuenta.saldo}');
      print('Cliente: ${cuenta.cliente.nombreCompleto}');
    } else {
      print('Error: No se encontró una cuenta con ese código.');
    }
  } else {
    print('Error: El código de cuenta es obligatorio.');
  }
}

void listarCuentas(Banco banco) {
  List<CuentaAhorro> cuentas = banco.listarCuentas();
  if (cuentas.isEmpty) {
    print('No hay cuentas registradas.');
  } else {
    print('Listado de cuentas:');
    for (var cuenta in cuentas) {
      print(
          'Código: ${cuenta.codigo}, Cliente: ${cuenta.cliente.nombreCompleto}, Saldo: ${cuenta.saldo}');
    }
  }
}
