import 'reserva.dart';
import 'reservas_repository.dart';

class CrearReserva {
  CrearReserva(this.repositorio);

  final ReservasRepository repositorio;

  Future<ResultadoReserva> call(SolicitudReserva solicitud) async {
    if (!solicitud.fin.isAfter(solicitud.inicio)) {
      return ResultadoReserva.rechazada(
        'La hora de fin debe ser posterior a la de inicio',
      );
    }

    final reservas = await repositorio.reservasDeSala(solicitud.salaId);
    for (final existente in reservas) {
      if (solicitud.inicio.isBefore(existente.fin) &&
          solicitud.fin.isAfter(existente.inicio)) {
        return ResultadoReserva.rechazada(
          'La sala ya está reservada en ese horario.',
        );
      }
    }

    final reserva = await repositorio.guardar(solicitud);
    return ResultadoReserva.aceptada(reserva);
  }
}
