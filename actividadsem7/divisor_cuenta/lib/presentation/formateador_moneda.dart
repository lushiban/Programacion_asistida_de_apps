class FormateadorMoneda {
  const FormateadorMoneda();

  String formatear(double valor) => valor.toStringAsFixed(2);
}
