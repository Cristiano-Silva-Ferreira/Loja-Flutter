bool emailValid(String email){
  final RegExp regex = RegExp(
      // Expressão regular para verificar um texto
      r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"
  );
  // Verficando se o email se encaixa nessa regra
  return regex.hasMatch(email);
}