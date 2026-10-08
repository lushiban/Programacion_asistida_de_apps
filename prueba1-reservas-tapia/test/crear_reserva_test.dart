import 'package:flutter_test/flutter_test.dart';
import 'package:reservas_sala/domain/crear_reserva.dart';
import 'package:reservas_sala/domain/reserva.dart';

import 'support/reservas_en_memoria.dart';

DateTime hora(int h, [int m = 0]) => DateTime(2026, 10, 14, h, m);

SolicitudReserva solicitud(String salaId, DateTime inicio, DateTime fin) =>
    SolicitudReserva(
      salaId: salaId,
      usuarioId: 'u1',
      inicio: inicio,
      fin: fin,
    );

void main() {
  late ReservasEnMemoria repositorio;
  late CrearReserva crearReserva;

  setUp(() {
    repositorio = ReservasEnMemoria();
    crearReserva = CrearReserva(repositorio);
  });

  test('acepta una reserva válida y la guarda', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva cuyo fin no es posterior al inicio', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(9),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La hora de fin debe ser posterior a la de inicio');
    expect(repositorio.reservas, isEmpty);
  });

  test('rechaza un solapamiento parcial', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9), hora(10)));

    final resultado = await crearReserva(
      solicitud('Sala A', hora(9, 30), hora(10, 30)),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario.');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva contenida en otra', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9), hora(11)));

    final resultado = await crearReserva(
      solicitud('Sala A', hora(9, 30), hora(10, 30)),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario.');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva que contiene otra', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9, 30), hora(10, 30)));

    final resultado = await crearReserva(
      solicitud('Sala A', hora(9), hora(11)),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario.');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza intervalos idénticos en la misma sala', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9), hora(10)));

    final resultado = await crearReserva(
      solicitud('Sala A', hora(9), hora(10)),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario.');
    expect(repositorio.reservas, hasLength(1));
  });

  test('permite intervalos consecutivos sin tiempo compartido', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9), hora(10)));

    final resultado = await crearReserva(
      solicitud('Sala A', hora(10), hora(11)),
    );

    expect(resultado.aceptada, isTrue);
    expect(resultado.reserva?.salaId, 'Sala A');
    expect(repositorio.reservas, hasLength(2));
  });

  test('permite el mismo horario en salas distintas', () async {
    await repositorio.guardar(solicitud('Sala A', hora(9), hora(10)));

    final resultado = await crearReserva(
      solicitud('Sala B', hora(9), hora(10)),
    );

    expect(resultado.aceptada, isTrue);
    expect(resultado.reserva?.salaId, 'Sala B');
    expect(repositorio.reservas, hasLength(2));
  });
}
