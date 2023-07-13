class UserFields{
  static final String id= 'ID';
  static final String firstName= 'First Name';
  static final String lastName= 'Last Name';
  static final String address= 'Address';
  static final String area= 'Area';
  static final String landline= 'Landline';
  static final String mobile= 'Mobile';
  static final String frontOfID= 'Front of the ID';
  static final String backOfID= 'Back of the ID';

static List<String>getFields()=> [id,firstName,lastName,address,area,landline,mobile,frontOfID,backOfID];

}
class User{
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? area;
  final String? landline;
  final String? mobile;
  final String? frontID;
  final String? backID;

const User({
   required this.id,
 this.firstName,
  this.lastName,
   this.address,
  this.area,
  this.landline,
  this.mobile,
  this.frontID,
  this.backID,
});
   User.national({
    required this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.area,
      this.landline,
      this.mobile,
     required this.frontID,
     required this.backID,
  });



Map<String,dynamic> toJson()=> {
  UserFields.id:id,
  UserFields.firstName:firstName,
  UserFields.lastName:lastName,
  UserFields.address:address,
  UserFields.area:area,
  UserFields.landline:landline,
  UserFields.mobile:mobile,
  UserFields.frontOfID:frontID,
  UserFields.backOfID:backID,
};



}