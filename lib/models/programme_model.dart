
class LectureModel{

  String? cycle;
  String? datefin;
  String? disponible;
  String? duree;
  String? etat;
  String? intitule;
  String? livrename;
  String? livreuid;
  String? productImageUrl;
  String? texte;
  String? uid;

  LectureModel({this.uid,this.cycle,this.disponible,this.datefin,this.duree,this.etat,this.intitule,this.livrename,this.livreuid,this.productImageUrl,this.texte});

  factory LectureModel.fromMap(map){
    return LectureModel(
      uid: map['uid'],
      cycle: map['cycle'],
      disponible: map['disponible'],
      datefin: map['datefin'],
      duree: map['duree'],
      etat: map['etat'],
      intitule: map['intitule'],
      livrename: map['livrename'],
      livreuid: map['livreuid'],
      productImageUrl: map['productImageUrl'],
      texte: map['texte'],
    );

  }

  Map<String,dynamic> toMap(){
    return {
      'uid':uid,
      'cycle':cycle,
      'disponible':disponible,
      'datefin':datefin,
      'duree':duree,
      'etat':etat,
      'intitule':intitule,
      'livrename':livrename,
      'livreuid':livreuid,
      'productImageUrl':productImageUrl,
      'texte':texte,
    };
}
}