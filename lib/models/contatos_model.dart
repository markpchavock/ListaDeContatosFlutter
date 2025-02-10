class ContatosModel {
  List<ContatosResults>? results;

  ContatosModel({this.results});

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ContatosResults>[];
      json['results'].forEach((v) {
        results!.add(ContatosResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContatosResults {
  String? objectId;
  String? nome;
  String? telefone;
  String? whatsapp;
  String? email;
  String? endereco;
  String? createdAt;
  String? updatedAt;
  String? photopath;

  ContatosResults(
      {this.objectId,
      this.nome,
      this.telefone,
      this.whatsapp,
      this.email,
      this.endereco,
      this.createdAt,
      this.updatedAt,
      this.photopath});

  ContatosResults.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    telefone = json['telefone'];
    whatsapp = json['whatsapp'];
    email = json['email'];
    endereco = json['endereco'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    photopath = json['photopath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['whatsapp'] = whatsapp;
    data['email'] = email;
    data['endereco'] = endereco;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['photopath'] = photopath;
    return data;
  }
}
