// Modularizando a API para não o APP não ficar depentende somente de uma, caso
// no futuro troque de API, bastar substituir as informações aqui

class Address {
  Address(
      {this.street,
      this.number,
      this.complement,
      this.district,
      this.zipCode,
      this.city,
      this.state,
      this.lat,
      this.long});

  String street;
  String number;
  String complement;
  String district;
  String zipCode;
  String city;
  String state;

  double lat;
  double long;
}
