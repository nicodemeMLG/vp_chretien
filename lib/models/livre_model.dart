class LivreModel{
  String? cycle;
  String? intitule;
  String? nbrechapitre;
  int? totalchapitre;
  String? uid;

  LivreModel({this.uid,this.intitule,this.cycle,this.nbrechapitre,this.totalchapitre});

  factory LivreModel.fromMap(map){
    return LivreModel(
      uid: map['uid'],
      intitule: map['intitule'],
      cycle: map['cycle'],
      nbrechapitre: map['nbrechapitre'],
      totalchapitre: map['totalchapitre'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'uid':uid,
      'cycle':cycle,
      'intitule':intitule,
      'nbrechapitre':nbrechapitre,
      'totalchapitre':totalchapitre,
    };
  }
}